output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = { for name, s in azurerm_subnet.snet : name => s.id }
}

output "nsg_ids" {
  value = { for name, n in azurerm_network_security_group.nsg : name => n.id }
}
