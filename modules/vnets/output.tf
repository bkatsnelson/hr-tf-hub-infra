output "hub_infra_vnet_id" {
  value = azurerm_virtual_network.hub_infra_vnet.id
}
output "hub_infra_vnet_name" {
  value = azurerm_virtual_network.hub_infra_vnet.name
}
output "js_linux_subnet_id" {
  value = azurerm_subnet.js_linux_subnet.id
}
output "js_windows_subnet_id" {
  value = azurerm_subnet.js_windows_subnet.id
}
output "storage_accounts_subnet_id" {
  value = azurerm_subnet.storage_accounts_subnet.id
}
output "key_vault_subnet_id" {
  value = azurerm_subnet.key_vault_subnet.id
}
