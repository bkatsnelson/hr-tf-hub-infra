resource "azurerm_route_table" "hub_vnet_disable_spoke_route_table" {
  name                = "hub-vnet-disable-spoke-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_route" "disable_spoke_vnet_access_route_rule" {
  name                = "disable-spoke-vnet-access-route-rule"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.hub_vnet_disable_spoke_route_table.name
  address_prefix      = "10.0.0.0/8"
  next_hop_type       = "None"
}
