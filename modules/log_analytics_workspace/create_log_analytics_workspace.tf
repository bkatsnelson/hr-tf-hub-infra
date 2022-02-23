resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "law-${var.resource_qualifier}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
