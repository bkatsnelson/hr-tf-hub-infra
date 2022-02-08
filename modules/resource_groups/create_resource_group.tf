
#----------------------------------------------------------
# Create Infra Resource Group
#----------------------------------------------------------

resource "azurerm_resource_group" "rg-hub-infra" {
  name     = "rg-${var.app}-${var.environment}-infra-${var.loc_acronym}-001"
  location = var.location
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}
