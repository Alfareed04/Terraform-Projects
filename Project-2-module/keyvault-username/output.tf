output "username" {
  value = azurerm_key_vault_secret.admin_username.name
}

output "admin_username" {
  value = azurerm_key_vault_secret.admin_username
}