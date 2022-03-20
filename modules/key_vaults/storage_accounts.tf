#---------------------------------------------------------------------
# Define Local Variables
#---------------------------------------------------------------------

locals {
  storage_qualifier = replace(var.resource_qualifier, "-", "")
}

#---------------------------------------------------------------------
# Storage Account For VM Diagnostics"
#---------------------------------------------------------------------

resource "azurerm_storage_account" "hub_kv_diag_storage" {
  name                              = "stsmbckvlg${local.storage_qualifier}"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  allow_blob_public_access          = false
  infrastructure_encryption_enabled = true

  network_rules {
    default_action = "Deny"
    ip_rules       = var.authorized_ip_ranges
  }

  tags = var.tags
}

#-----------------------------------------------------------------
# Create Hub Key Vault Private Endpoint
#-----------------------------------------------------------------

resource "azurerm_private_endpoint" "hub_kv_diag_storage_private_endpoint" {
  name                = "pe-stsmbckvlg${local.storage_qualifier}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.key_vault_subnet_id

  private_dns_zone_group {
    name                 = "pdnszgroup-kv-${var.resource_qualifier}-001"
    private_dns_zone_ids = [var.hub_blob_private_dns_id]
  }

  private_service_connection {
    name                           = azurerm_storage_account.hub_kv_diag_storage.name
    private_connection_resource_id = azurerm_storage_account.hub_kv_diag_storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
