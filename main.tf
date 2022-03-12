
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
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-eastus"
    storage_account_name = "stsmbcbkatsnelsonuse"
    container_name       = "tf-hub-infra"
    key                  = "terraform.state"
    subscription_id      = "c15bb9c5-2f4d-4112-b6d0-aa2434d885c9"
    tenant_id            = "c7f6413d-1e73-45d2-b0da-a68713b515a7"
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

#----------------------------------------------------------
# Local Variables
#----------------------------------------------------------

locals {
  address_space      = var.address_space_map[var.location]
  loc_acronym        = var.loc_acronym_map[var.location]
  resource_qualifier = "${var.app}-${var.environment}-${local.loc_acronym}"
  tags = {
    Environment = title(var.app),
    Cost_Center = title(var.cost_center)
  }
}

#----------------------------------------------------------
# Create Hub Infrastructure Resource Group
#----------------------------------------------------------

module "resource_groups" {
  source = "./modules/resource_groups"

  location           = var.location
  resource_qualifier = local.resource_qualifier
  tags               = local.tags
}

#----------------------------------------------------------
# Create Hub Network Watches
#----------------------------------------------------------

module "network_watcher" {
  source = "./modules/network_watcher"

  location            = var.location
  resource_qualifier  = local.resource_qualifier
  resource_group_name = module.resource_groups.NetworkWatcherRG_Name
  tags                = local.tags
}

#----------------------------------------------------------
# Create Hub Log Analytics Wowrkspace
#----------------------------------------------------------

module "log_analytics_workspace" {
  source              = "./modules/log_analytics_workspace"
  location            = var.location
  resource_qualifier  = local.resource_qualifier
  resource_group_name = module.resource_groups.rg_hub_infra_name
  tags                = local.tags
}
#----------------------------------------------------------
# Create Application Security Groups
#----------------------------------------------------------

module "application_security_groups" {
  source = "./modules/application_security_groups"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
  loc_acronym         = local.loc_acronym
  tags                = local.tags
}

#----------------------------------------------------------
# Create Network Security Groups
#----------------------------------------------------------

module "network_security_groups" {
  source = "./modules/network_security_groups"

  location              = var.location
  resource_group_name   = module.resource_groups.rg_hub_infra_name
  loc_acronym           = local.loc_acronym
  authorized_ip_ranges  = var.authorized_ip_ranges
  asg_hub_js_linux_id   = module.application_security_groups.asg_hub_js_linux_id
  asg_hub_js_windows_id = module.application_security_groups.asg_hub_js_windows_id
  tags                  = local.tags
}

#----------------------------------------------------------
# Create Network Routes
#----------------------------------------------------------

module "routes" {
  source = "./modules/routes"

  location            = var.location
  resource_group_name = module.resource_groups.rg_hub_infra_name
  tags                = local.tags
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
  nsg_key_vaults_id                     = module.network_security_groups.nsg_hub_key_vaults_id
  hub_vnet_disable_spoke_route_table_id = module.routes.hub_vnet_disable_spoke_route_table_id
  tags                                  = local.tags
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
  tags                = local.tags
}

#----------------------------------------------------------
# Create Key Vault and Keys
#----------------------------------------------------------

module "key_vaults" {
  source = "./modules/key_vaults"

  location             = var.location
  resource_group_name  = module.resource_groups.rg_hub_infra_name
  resource_qualifier   = local.resource_qualifier
  tenant_id            = var.tenant_id
  authorized_ip_ranges = var.authorized_ip_ranges
  key_vault_subnets    = [module.hub_infra_vnet.js_linux_subnet_id, module.hub_infra_vnet.js_windows_subnet_id]
  hub_law_id           = module.log_analytics_workspace.hub_law_id
  tags                 = local.tags
}

#----------------------------------------------------------
# Create Virtual Machines
#----------------------------------------------------------

module "virtual_machines" {
  source = "./modules/virtual_machines"

  location                   = var.location
  resource_group_name        = module.resource_groups.rg_hub_infra_name
  resource_qualifier         = local.resource_qualifier
  app                        = var.app
  environment                = var.environment
  js_linux_subnet_id         = module.hub_infra_vnet.js_linux_subnet_id
  asg_hub_js_linux_id        = module.application_security_groups.asg_hub_js_linux_id
  js_windows_subnet_id       = module.hub_infra_vnet.js_windows_subnet_id
  asg_hub_js_windows_id      = module.application_security_groups.asg_hub_js_windows_id
  hub_law_workspace_id       = module.log_analytics_workspace.hub_law_workspace_id
  hub_law_primary_shared_key = module.log_analytics_workspace.hub_law_primary_shared_key
  authorized_ip_ranges       = var.authorized_ip_ranges
  hub_key_vault_001_id       = module.key_vaults.hub_key_vault_001_id
  tenant_id                  = var.tenant_id
  tags                       = local.tags
}

#----------------------------------------------------------
# End of File
#----------------------------------------------------------
