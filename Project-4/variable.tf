# variable "resource_name" {
#   type = string
# }

# variable "resource_location" {
#   type = string
# }

variable "subnets" {
  type = map(object({
    subnet_name = string
    address_prefix = string
  }))
}

variable "virtual_machine_name" {
  type = string
}

variable "os_disk_name" {
  type = string
}

variable "disk_encryption_name" {
  type = string
  
}
variable "nic_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}
 variable "key_name" {
   type = string
 }