output "nsg_hub_mgmt_id" {
  value = azurerm_network_security_group.nsg_hub_mgmt.id
}
output "nsg_hub_dmz_id" {
  value = azurerm_network_security_group.nsg_hub_dmz.id
}

output "nsg_hub_storage_accounts_id" {
  value = azurerm_network_security_group.nsg_hub_storage_accounts.id
}
