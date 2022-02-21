
#------------------------------------------------------------------------
# Create Application Security Groups For Linux and Windows Jump Servers
#------------------------------------------------------------------------

resource "azurerm_application_security_group" "asg_hub_js_linux" {
  name                = "asg-js-linux-${var.loc_acronym}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_application_security_group" "asg_hub_js_windows" {
  name                = "asg-js-windows-${var.loc_acronym}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}
