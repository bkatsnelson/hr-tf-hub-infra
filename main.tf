
###########################################################
#
# Description: Maintain Azure Hub Resources 
#
#
# Author: Boris Katsnelson
#   Date: 02/2022
#
###########################################################

#----------------------------------------------------------
# Configure the Azure provider
#----------------------------------------------------------

terraform {
  required_version = ">= 1.1.5"
}

provider "azurerm" {
  features {}
}

#----------------------------------------------------------
# Local Variables
#----------------------------------------------------------

locals {
  address_space = var.address_space_map[var.location]
  loc_acronym   = var.loc_acronym_map[var.location]
}

#----------------------------------------------------------
# Create Hub Infrastructure Resource Group
#----------------------------------------------------------

module "resource_groups" {
  source = "./modules/resource_groups"

  location    = var.location
  app         = var.app
  environment = var.environment
  loc_acronym = local.loc_acronym
}

#----------------------------------------------------------
# Create Hub Network Watches
#----------------------------------------------------------

module "network_watcher" {
  source = "./modules/network_watcher"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
  app                 = var.app
  environment         = var.environment
  loc_acronym         = local.loc_acronym
}

#----------------------------------------------------------
# Create Application Security Groups
#----------------------------------------------------------

module "application_security_groups" {
  source = "./modules/application_security_groups"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
}

#----------------------------------------------------------
# Create Network Security Groups
#----------------------------------------------------------

module "network_security_groups" {
  source = "./modules/network_security_groups"

  location             = var.location
  resource_group_name  = module.resource_groups.rg_hub_infra_name
  authorized_ip_ranges = var.authorized_ip_ranges
}

#----------------------------------------------------------
# Create Network Routes
#----------------------------------------------------------

module "routes" {
  source = "./modules/routes"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
}

#----------------------------------------------------------
# Create Virtual Network 
#----------------------------------------------------------

module "hub_infra_vnet" {
  source = "./modules/vnets"

  location                              = var.location
  resource_group_name                   = module.resource_groups.rg_hub_infra_name
  address_space                         = local.address_space
  nsg_dmz_id                            = module.network_security_groups.nsg_hub_dmz_id
  nsg_mgmt_id                           = module.network_security_groups.nsg_hub_mgmt_id
  nsg_storage_accounts_id               = module.network_security_groups.nsg_hub_storage_accounts_id
  hub_vnet_disable_spoke_route_table_id = module.routes.hub_vnet_disable_spoke_route_table_id
}

#----------------------------------------------------------
# Create Virtual Machines
#----------------------------------------------------------

module "hub_private_dns" {
  source = "./modules/private_dns"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
  hub_infra_vnet_id   = module.hub_infra_vnet.hub_infra_vnet_id
  smbc_hub_domain     = var.smbc_hub_domain
}

#----------------------------------------------------------
# Create Virtual Machines
#----------------------------------------------------------

module "virtual_machines" {
  source = "./modules/virtual_machines"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
  dmz_subnet_id       = module.hub_infra_vnet.dmz_subnet_id
  asg_dmz_id          = module.application_security_groups.asg_hub_dmz_id
}

#----------------------------------------------------------
# End of File
#----------------------------------------------------------
