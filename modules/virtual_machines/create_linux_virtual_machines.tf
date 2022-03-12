
#------------------------------------------------------------------------
# Define Local Variables
#------------------------------------------------------------------------

locals {
  vm_prefix = "vm${var.app}${var.environment}linux"
}

#------------------------------------------------------------------------
# Create Virtual Machines Public IP and Network Interface
#------------------------------------------------------------------------

resource "azurerm_public_ip" "pip_vmlinux01" {
  name                = "pip_${local.vm_prefix}01"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  domain_name_label   = "${local.vm_prefix}01"
  sku                 = "Basic"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic_vmlinux01" {
  name                = "nic_${local.vm_prefix}01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.js_linux_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_vmlinux01.id
  }

  tags = var.tags
}

#------------------------------------------------------------------------
# Assign NIC to Application Securoty Group
#------------------------------------------------------------------------

resource "azurerm_network_interface_application_security_group_association" "asg_dmz_vmlinux01_association" {
  network_interface_id          = azurerm_network_interface.nic_vmlinux01.id
  application_security_group_id = var.asg_hub_js_linux_id
}

#------------------------------------------------------------------------
# Create VM Public and Private Keys
#------------------------------------------------------------------------

resource "tls_private_key" "vmlinux01_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_ssh_public_key" "vmlinux01_ssh_public_key" {
  name                = "${local.vm_prefix}01_ssh_public_key"
  location            = var.location
  resource_group_name = var.resource_group_name
  public_key          = tls_private_key.vmlinux01_private_key.public_key_openssh
  tags                = var.tags
}

#------------------------------------------------------------------------
# Create Managed Disk
#------------------------------------------------------------------------

resource "azurerm_managed_disk" "vmlinux01_managed_disk_001" {
  name                 = "${local.vm_prefix}01-managed-disk-001"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  disk_encryption_set_id = azurerm_disk_encryption_set.hub_js_disk_encryption_set_001.id

  tags = var.tags

}

#------------------------------------------------------------------------
# Create Virtual Machine
#------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "vmlinux01" {
  name                            = "${local.vm_prefix}01"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic_vmlinux01.id]
  size                            = "Standard_B2ms"
  patch_mode                      = "AutomaticByPlatform"
  provision_vm_agent              = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_disk {
    name                   = "${local.vm_prefix}01_OsDisk_1"
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = 30
    disk_encryption_set_id = azurerm_disk_encryption_set.hub_js_disk_encryption_set_001.id
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.vmlinux01_private_key.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.hub_vm_diag_storage.primary_blob_endpoint
  }

  tags = var.tags
}

#----------------------------------------------------------
# Configure Auto Shutdown
#----------------------------------------------------------

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vmlinux01_auto_shutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.vmlinux01.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = "1700"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }

  tags = var.tags

}

#----------------------------------------------------------
# Configure Backup
#----------------------------------------------------------

// az backup container list 
// --backup-management-type AzureIaasVM -g rg-hub-shr-use2-001 -v rsv-hub-shr-use2

resource "azurerm_backup_protected_vm" "vmlinux01_backup" {

  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.hub_recovery_service_vault.name
  source_vm_id        = azurerm_linux_virtual_machine.vmlinux01.id
  backup_policy_id    = azurerm_backup_policy_vm.hub_vm_backup_policy.id

  // Does not work 03/2022
  // tags = var.tags

}
