#-----------------------------------------------------------------------------
# Create Network Security Groups
#-----------------------------------------------------------------------------

resource "azurerm_network_security_group" "nsg_allowssh_001" {
  name                = "nsg-allowssh-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                                       = "allowssh_security_rule"
    priority                                   = 1000
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_address_prefixes                    = var.authorized_ip_ranges
    source_port_range                          = "*"
    destination_port_range                     = "22"
    destination_application_security_group_ids = [var.asg_hub_js_linux_id]
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "nsg_allowrdp_001" {
  name                = "nsg-allowrdp-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                                       = "allowrdp_security_rule"
    priority                                   = 1100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_address_prefixes                    = var.authorized_ip_ranges
    source_port_range                          = "*"
    destination_port_range                     = "3389"
    destination_application_security_group_ids = [var.asg_hub_js_windows_id]
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "nsg_hub_storage_accounts" {
  name                = "nsg-hub-storage-accounts-${var.loc_acronym}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "nsg_hub_key_vaults" {
  name                = "nsg-hub-key-vaults-${var.loc_acronym}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

