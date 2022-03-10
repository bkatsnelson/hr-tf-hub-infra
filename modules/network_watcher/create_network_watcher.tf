
#-------------------------------------------------------------
#  Create Network Watcher
#-------------------------------------------------------------

# Notes: Use default resource group to enable MS Defender for Cloud to find it

resource "azurerm_network_watcher" "hub-network-watcher" {
  name                = "nw-${var.resource_qualifier}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
