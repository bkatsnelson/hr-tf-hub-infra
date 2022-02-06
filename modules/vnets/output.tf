output "hub_infra_vnet_id" {
  value = azurerm_virtual_network.hub_infra_vnet.id
}
output "hub_infra_vnet_name" {
  value = azurerm_virtual_network.hub_infra_vnet.name
}
output "dmz_subnet_id" {
  value = azurerm_subnet.dmz_subnet.id
}
output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt_subnet.id
}
output "storage_accounts_subnet_id" {
  value = azurerm_subnet.storage_accounts_subnet.id
}
output "key_vault_subnet_id" {
  value = azurerm_subnet.key_vault_subnet.id
}
