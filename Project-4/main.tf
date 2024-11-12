terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"           // Create a Resource Group using Terraform

}
 
provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "rg" {
  name = "Project3-rg"
}

data "azurerm_virtual_network" "vnet" {
  name = "project3_vnet"
  resource_group_name = "Project3-rg"

  depends_on = [ data.azurerm_resource_group.rg ]
}

module "subnets" {
  source = "../Project-2-module/subnet"
  for_each = var.subnets
  subnet_name = each.key
  address_prefix = each.value.address_prefix
  virtual_name = data.azurerm_virtual_network.vnet.name
  resource_name = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [ data.azurerm_virtual_network.vnet ]
}

//Keyvault 

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

module "keyvault" {
  source = "../Project-2-module/keyvault"
  keyvault_name = var.keyvault_name
  resource_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  soft_delete_retention_days = 30
}

module "keyvault_policy" {
  source = "../Project-2-module/keyvault-policy"
  keyvault_id = module.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_client_config.current.object_id
  secret_permissions = [
      "Get",
      "Set",
      "Backup",
      "Delete",
      "Purge", 
      "List",
      "Recover",
      "Restore",
    ]
}

module "admin_username" {
  source = "../Project-2-module/keyvault-username"
  username = "proj4-username"
  value = var.admin_username
  key_vault_id = module.keyvault.id
  depends_on = [ module.keyvault, module.keyvault_policy ]
}

module "admin_password" {
  source = "../Project-2-module/keyvault-password"
  password = "proj4-password"
  value = var.admin_password
  key_vault_id = module.keyvault.id
  depends_on = [ module.admin_username ]
}

module "keyvault_key" {
  source = "../Project-2-module/keyvault-key"
  key_name = var.key_name
  key_vault_id = module.keyvault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt"] 
  depends_on = [ module.keyvault,module.keyvault_policy ]
}

module "disk_encryption" {
  source = "../Project-2-module/disk-encryption"
  disk_encryption_name = var.disk_encryption_name
  resource_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  key_vault_key_id = module.keyvault.id

  depends_on = [ module.keyvault_key ]
}

module "nic" {
  source = "../Project-2-module/nic"
  nic_name = var.nic_name
  resource_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  ip_configuration_name = "internal"
  subnet_id = module.subnets["subnet01"].subnet_id
  private_ip_address_allocation = "Dynamic"

  depends_on = [ data.azurerm_resource_group.rg, data.azurerm_virtual_network.vnet, module.subnets ]
}

module "virtual_machine" {
source = "../Project-2-module/virtual-machine"
vm_name = var.virtual_machine_name
resource_name = data.azurerm_resource_group.rg.name
location = data.azurerm_resource_group.rg.location
vm_size = "Standard_B1s"
admin_username = var.admin_username
admin_password = var.admin_password
network_interface_ids = [ module.nic.id ]
os_disk_name = var.os_disk_name
os_disk_caching            = "ReadWrite"
os_disk_storage_account_type = "Premium_LRS"
disk_encryption_set_id     = module.disk_encryption.id
image_publisher            = "Canonical"
image_offer                = "UbuntuServer"
image_sku                  = "18.04-LTS"
image_version              = "latest"

depends_on = [ data.azurerm_resource_group.rg, module.keyvault, module.admin_username, module.admin_password, module.nic,
module.disk_encryption ]
}

