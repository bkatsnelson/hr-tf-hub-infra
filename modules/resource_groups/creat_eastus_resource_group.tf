
#----------------------------------------------------------
# Create Infra Resource Group
#----------------------------------------------------------

resource "azurerm_resource_group" "rg-hub-infra" {
  name     = "rg-${var.location}-hub-infra"
  location = var.location
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}
