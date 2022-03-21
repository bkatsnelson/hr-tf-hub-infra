resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "law-${var.resource_qualifier}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

#-----------------------------------------------------------------
# Set Hub Key Vault Diagnostics
#-----------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "hub_log_analitics_st_diag" {
  name               = "law-${var.resource_qualifier}-001-st-diag"
  target_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  storage_account_id = var.hub_diag_storage_id

  log {
    category = "audit"
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
