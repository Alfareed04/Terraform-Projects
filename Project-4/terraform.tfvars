# resource_name = "Project4-rg"
# resource_location = "East US"

subnets = {
  "subnet01" = {
    subnet_name = "subnet01"
    address_prefix = "10.2.5.0/24"
  },
  "subnet02" = {
    subnet_name = "subnet02"
    address_prefix = "10.2.6.0/24"
  }
}

virtual_machine_name = "project4-vm"
nic_name = "VM-nic"
keyvault_name = "project4-KeyVault"
admin_password = "@15432!"
admin_username = "azureuser"
disk_encryption_name = "Diskencryption"
key_name = "Disk-key"
os_disk_name = "VM-disk"