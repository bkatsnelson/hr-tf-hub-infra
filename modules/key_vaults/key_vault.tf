
#-----------------------------------------------------------------
# Create Hub Key Vault
#-----------------------------------------------------------------

resource "azurerm_key_vault" "hub_key_vault_001" {

  name                        = "kv-${var.resource_qualifier}-001"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  // depricated - soft_delete_enabled         = true
  purge_protection_enabled = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.authorized_ip_ranges
    virtual_network_subnet_ids = var.key_vault_subnets
  }

  tags = var.tags

}

#-----------------------------------------------------------------
# Set Hub Key Vault Diagnostics
#-----------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "hub_key_vault_001_st_diag" {
  name               = "kv-${var.resource_qualifier}-001-st-diag"
  target_resource_id = azurerm_key_vault.hub_key_vault_001.id
  storage_account_id = azurerm_storage_account.hub_kv_diag_storage.id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 7
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "hub_key_vault_001_law_diag" {
  name                       = "kv-${var.resource_qualifier}-001-law-diag"
  target_resource_id         = azurerm_key_vault.hub_key_vault_001.id
  log_analytics_workspace_id = var.hub_law_id
  // log_analytics_destination_type = "Dedicated"

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 7
    }
  }
}

