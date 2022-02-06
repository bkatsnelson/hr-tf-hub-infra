
#----------------------------------------------------------
# Create Application Security Groups
#----------------------------------------------------------

resource "azurerm_application_security_group" "asg_hub_mgmt" {
  name                = lower("asg-mgmt-${var.location}")
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_application_security_group" "asg_hub_dmz" {
  name                = lower("asg-dmz-${var.location}")
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

