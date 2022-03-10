
#----------------------------------------------------------
# Create Infra Resource Group
#----------------------------------------------------------

resource "azurerm_resource_group" "rg-hub-infra" {
  name     = "rg-${var.resource_qualifier}-001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "NetworkWatcherRG" {
  name     = "NetworkWatcherRG"
  location = var.location
  tags     = var.tags
}

