
#---------------------------------------------------------------------
# Recovery Services Vault
#---------------------------------------------------------------------

resource "azurerm_recovery_services_vault" "hub_recovery_service_vault" {
  name                = "rsv-${var.resource_qualifier}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = var.tags

}

#---------------------------------------------------------------------
# Backup Policy
#---------------------------------------------------------------------

resource "azurerm_backup_policy_vm" "hub_vm_backup_policy" {
  name                = "bplcy-vm-backup-policy-${var.resource_qualifier}"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.hub_recovery_service_vault.name

  timezone = "Eastern Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  tags = var.tags
}
