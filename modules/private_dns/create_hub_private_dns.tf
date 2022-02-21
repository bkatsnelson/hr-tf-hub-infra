#----------------------------------------------------------
# Create a Hub Private DNS Zone And Associate With Hub Vnet
#----------------------------------------------------------

resource "azurerm_private_dns_zone" "hub_smbc_private_dns" {
  name                = var.smbc_hub_domain
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdnslink_vnet_hub_smbc" {
  name                  = "pdnslink-vnet-hub-smbc-${var.location}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.hub_smbc_private_dns.name
  virtual_network_id    = var.hub_infra_vnet_id
  registration_enabled  = true
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}
