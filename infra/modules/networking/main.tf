resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# One NSG per subnet
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnets
  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Subnets with conditional delegation/policies
resource "azurerm_subnet" "snet" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.cidr]

  dynamic "delegation" {
    for_each = each.value.delegate_to_appservice ? [1] : []
    content {
      name = "appservice_delegation"
      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
  private_link_service_network_policies_enabled = lookup(each.value, "enable_private_link_service_policies", false)
}

# NSG ↔ Subnet association
resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Flatten NSG rules per subnet
locals {
  subnet_rule_map = merge([
    for s_name, s_val in var.subnets : {
      for r_name, r_val in coalesce(s_val.nsg_rules, {}) :
      "${s_name}:${r_name}" => {
        subnet = s_name
        name   = r_name
        rule   = r_val
      }
    }
  ]...)
}

resource "azurerm_network_security_rule" "rules" {
  for_each = local.subnet_rule_map

  name                       = each.value.name
  priority                   = each.value.rule.priority
  direction                  = each.value.rule.direction
  access                     = each.value.rule.access
  protocol                   = each.value.rule.protocol
  source_port_range          = each.value.rule.source_port_range
  destination_port_range     = each.value.rule.destination_port_range
  source_address_prefix      = each.value.rule.source_address_prefix
  destination_address_prefix = each.value.rule.destination_address_prefix

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.subnet].name
}
