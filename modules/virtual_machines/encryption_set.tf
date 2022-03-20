
#-------------------------------------------------------------------------
# Get Current User Info
#-------------------------------------------------------------------------

data "azurerm_client_config" "current" {}

#-------------------------------------------------------------------------
# Create Disk Encryption Set
#-------------------------------------------------------------------------

resource "azurerm_key_vault_key" "hub_js_des_key_001" {
  name         = "deskey-${var.resource_qualifier}-001"
  key_vault_id = var.hub_key_vault_001_id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]

  expiration_date = "2024-03-12T14:00:00Z"

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "hub_js_disk_encryption_set_001" {
  name                = "des-${var.resource_qualifier}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.hub_js_des_key_001.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "hub_js_kv_access_policy_001" {
  key_vault_id = var.hub_key_vault_001_id

  tenant_id = azurerm_disk_encryption_set.hub_js_disk_encryption_set_001.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.hub_js_disk_encryption_set_001.identity.0.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = var.hub_key_vault_001_id

  tenant_id = var.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get",
    "create",
    "delete",
    "list",
    "recover",
    "update"
  ]
}
