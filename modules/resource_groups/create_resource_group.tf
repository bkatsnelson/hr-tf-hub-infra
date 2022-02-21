
#----------------------------------------------------------
# Create Infra Resource Group
#----------------------------------------------------------

resource "azurerm_resource_group" "rg-hub-infra" {
  name     = "rg-${var.resource_qualifier}-001"
  location = var.location
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}
