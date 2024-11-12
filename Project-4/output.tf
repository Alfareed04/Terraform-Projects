output "rg" {
  value = data.azurerm_resource_group.rg
}

output "vnet" {
  value = data.azurerm_virtual_network.vnet
}

output "subnet" {
  value = module.subnets
}

output "keyvault" {
  value = module.keyvault
}

output "nic" {
  value = module.nic
}

output "disk_encryption" {
  value = module.disk_encryption
}
