
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
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

#----------------------------------------------------------
# Local Variables
#----------------------------------------------------------

locals {
  address_space      = var.address_space_map[var.location]
  loc_acronym        = var.loc_acronym_map[var.location]
  resource_qualifier = "${var.app}-${var.environment}-${local.loc_acronym}"
}

#----------------------------------------------------------
# Create Hub Infrastructure Resource Group
#----------------------------------------------------------

module "resource_groups" {
  source = "./modules/resource_groups"

  location           = var.location
  resource_qualifier = local.resource_qualifier
}

#----------------------------------------------------------
# Create Hub Network Watches
#----------------------------------------------------------

module "network_watcher" {
  source = "./modules/network_watcher"

  location            = var.location
  resource_qualifier  = local.resource_qualifier
  resource_group_name = module.resource_groups.NetworkWatcherRG_Name

}

#----------------------------------------------------------
# Create Hub Log Analytics Wowrkspace
#----------------------------------------------------------

module "log_analytics_workspace" {
  source              = "./modules/log_analytics_workspace"
  location            = var.location
  resource_qualifier  = local.resource_qualifier
  resource_group_name = module.resource_groups.rg_hub_infra_name

}
#----------------------------------------------------------
# Create Application Security Groups
#----------------------------------------------------------

module "application_security_groups" {
  source = "./modules/application_security_groups"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
  loc_acronym         = local.loc_acronym
}

#----------------------------------------------------------
# Create Network Security Groups
#----------------------------------------------------------

module "network_security_groups" {
  source = "./modules/network_security_groups"

  location              = var.location
  resource_group_name   = module.resource_groups.rg_hub_infra_name
  authorized_ip_ranges  = var.authorized_ip_ranges
  asg_hub_js_linux_id   = module.application_security_groups.asg_hub_js_linux_id
  asg_hub_js_windows_id = module.application_security_groups.asg_hub_js_windows_id
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
  resource_qualifier                    = local.resource_qualifier
  address_space                         = local.address_space
  nsg_allowssh_001_id                   = module.network_security_groups.nsg_allowssh_001_id
  nsg_allowrdp_001_id                   = module.network_security_groups.nsg_allowrdp_001_id
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

  location              = var.location
  resource_group_name   = module.resource_groups.rg_hub_infra_name
  app                   = var.app
  environment           = var.environment
  js_linux_subnet_id    = module.hub_infra_vnet.js_linux_subnet_id
  asg_hub_js_linux_id   = module.application_security_groups.asg_hub_js_linux_id
  js_windows_subnet_id  = module.hub_infra_vnet.js_windows_subnet_id
  asg_hub_js_windows_id = module.application_security_groups.asg_hub_js_windows_id
}

#----------------------------------------------------------
# End of File
#----------------------------------------------------------
