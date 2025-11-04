variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "vnet_address_space" {
  description = "CIDRs da VNet."
  type        = list(string)
}

variable "subnets" {
  description = "Mapa de subnets com configurações e regras de NSG."
  type = map(object({
    cidr                                 = string
    delegate_to_appservice               = optional(bool, false)
    enable_private_endpoint_policies     = optional(bool, false)
    enable_private_link_service_policies = optional(bool, false)
    nsg_rules = optional(map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), {})
  }))
}
