output "password" {
  value = azurerm_key_vault_secret.admin_password.name
}

output "admin_password" {
  value = azurerm_key_vault_secret.admin_password
}