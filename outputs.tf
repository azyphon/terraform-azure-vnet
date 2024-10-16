output "config" {
  description = "contains the virtual network configuration"
  value = azurerm_virtual_network.vnet
}

#output "subnets" {
  #value = azurerm_subnet.subnets
#}

#output "network_security_group" {
  #value = azurerm_network_security_group.nsg
#}
