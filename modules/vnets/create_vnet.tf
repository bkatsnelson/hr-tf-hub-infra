
###########################################################
#
# Description: Create Hub Vnet with Subnets
#
#
# Author: Boris Katsnelson
#   Date: 10/2021
#
###########################################################

#----------------------------------------------------------
# Define Local Variables
#----------------------------------------------------------

locals {
  address_prefix = substr(var.address_space[0], 0, 6)
}

#----------------------------------------------------------
# Create a virtual network 
#----------------------------------------------------------

resource "azurerm_virtual_network" "hub_infra_vnet" {
  name                = lower("vnet-hub-infra-${var.location}-001")
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

#----------------------------------------------------------
# Add Subnets and Assign Network Security Groups
#----------------------------------------------------------

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_infra_vnet.name
  address_prefixes     = ["${local.address_prefix}.1.0/24"]
}

resource "azurerm_subnet" "dmz_subnet" {

  name                 = "snet-dmz-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_infra_vnet.name
  address_prefixes     = ["${local.address_prefix}.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "dmz_subnet_nsg" {
  subnet_id                 = azurerm_subnet.dmz_subnet.id
  network_security_group_id = var.nsg_dmz_id
}

resource "azurerm_subnet" "mgmt_subnet" {

  name                 = "snet-mgmt-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_infra_vnet.name
  address_prefixes     = ["${local.address_prefix}.3.0/24"]

}

resource "azurerm_subnet_network_security_group_association" "mgmt_subnet_nsg" {
  subnet_id                 = azurerm_subnet.mgmt_subnet.id
  network_security_group_id = var.nsg_mgmt_id
}

resource "azurerm_subnet_route_table_association" "mgmt_subnet_route_table" {
  subnet_id      = azurerm_subnet.mgmt_subnet.id
  route_table_id = var.hub_vnet_disable_spoke_route_table_id
}

resource "azurerm_subnet" "storage_accounts_subnet" {

  name                                           = "snet-storage-accounts-001"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.hub_infra_vnet.name
  address_prefixes                               = ["${local.address_prefix}.4.0/24"]
  enforce_private_link_endpoint_network_policies = true

}

resource "azurerm_subnet_network_security_group_association" "storage_accounts_subnet_nsg" {
  subnet_id                 = azurerm_subnet.storage_accounts_subnet.id
  network_security_group_id = var.nsg_storage_accounts_id
}

resource "azurerm_subnet" "key_vault_subnet" {

  name                                           = "snet-key-vault-001"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.hub_infra_vnet.name
  address_prefixes                               = ["${local.address_prefix}.5.0/24"]
  enforce_private_link_endpoint_network_policies = true

}
resource "azurerm_subnet" "ad_subnet" {

  name                                           = "snet-ad-001"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.hub_infra_vnet.name
  address_prefixes                               = ["${local.address_prefix}.6.0/24"]
  enforce_private_link_endpoint_network_policies = true

}


