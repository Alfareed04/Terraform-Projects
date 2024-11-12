variable "keyvault_name" {
  type = string
}

variable "location" {
  type        = string
}

variable "resource_name" {
  type        = string
}

variable "sku_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "purge_protection_enabled" {
  type = bool
}

variable "soft_delete_retention_days" {
  type = number
}