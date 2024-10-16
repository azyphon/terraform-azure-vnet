output "config" {
  description = "contains virtual network configuration"
  value = azurerm_virtual_network.vnet
}

output "subnets" {
  description = "contains subnets configuration"
  value = azurerm_subnet.subnets
}
