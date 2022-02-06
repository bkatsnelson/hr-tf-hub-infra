#-----------------------------------------------------------------------------
# Create Network Security Groups
#-----------------------------------------------------------------------------

resource "azurerm_network_security_group" "nsg_hub_mgmt" {
  name                = "nsg-vm-hub-infra-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_network_security_group" "nsg_hub_dmz" {
  name                = "nsg-dmz-hub-infra-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "dmz_ssh_allow_security_rule"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = var.authorized_ip_ranges
    source_port_range          = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_network_security_group" "nsg_hub_storage_accounts" {
  name                = "nsg-storage-accounts-hub-infra-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

