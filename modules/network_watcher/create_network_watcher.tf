
#-------------------------------------------------------------
#  Create Network Watcher
#-------------------------------------------------------------

resource "azurerm_network_watcher" "hub-network-watcher" {
  name                = "${var.location}-hub-network-watcher"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}
