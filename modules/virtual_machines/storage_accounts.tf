#------------------------------------------------
# Define Local Variables
#------------------------------------------------

locals {
  storage_qualifier = replace(var.resource_qualifier, "-", "")
}

#------------------------------------------------
# Storage Account For VM Diagnostics"
#------------------------------------------------

resource "azurerm_storage_account" "hub_vm_diag_storage" {
  name                     = "stsmbcvmdiag${local.storage_qualifier}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = false

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.authorized_ip_ranges
    virtual_network_subnet_ids = [var.js_linux_subnet_id, var.js_windows_subnet_id]
  }

  tags = var.tags
}
