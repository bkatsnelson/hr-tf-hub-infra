#--------------------------------------------------------------------
# Create a Hub Private DNS Zone And Associate With Hub Vnet
#--------------------------------------------------------------------

resource "azurerm_private_dns_zone" "hub_smbc_private_dns" {
  name                = var.smbc_hub_domain
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdnslink_vnet_hub_smbc" {
  name                  = "pdnslink-vnet-hub-smbc-${var.location}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.hub_smbc_private_dns.name
  virtual_network_id    = var.hub_infra_vnet_id
  registration_enabled  = true
  tags                  = var.tags
}

#--------------------------------------------------------------------
# Create a Hub Key Vault Private DNS Zone And Associate With Hub Vnet
#--------------------------------------------------------------------

resource "azurerm_private_dns_zone" "hub_key_vaukt_private_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdnslink_vnet_hub_key_vault" {
  name                  = "pdnslink-vnet-hub-kv-${var.location}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.hub_key_vaukt_private_dns.name
  virtual_network_id    = var.hub_infra_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

#--------------------------------------------------------------------
# Create a Hub Blob Storage Private DNS Zone And Associate With Hub Vnet
#--------------------------------------------------------------------

resource "azurerm_private_dns_zone" "hub_blob_private_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdnslink_vnet_hub_blob" {
  name                  = "pdnslink-vnet-hub-blob-${var.location}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.hub_blob_private_dns.name
  virtual_network_id    = var.hub_infra_vnet_id
  registration_enabled  = false
  tags                  = var.tags
}
