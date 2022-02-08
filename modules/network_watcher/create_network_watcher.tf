
#-------------------------------------------------------------
#  Create Network Watcher
#-------------------------------------------------------------

resource "azurerm_network_watcher" "hub-network-watcher" {
  name                = "nw-${var.app}-${var.environment}-infra-{var.loc_acronym}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}
