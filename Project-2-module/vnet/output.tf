output "vnet_name" {
  value = azurerm_virtual_network.vnet
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "name" {
  value = azurerm_virtual_network.vnet.name
}