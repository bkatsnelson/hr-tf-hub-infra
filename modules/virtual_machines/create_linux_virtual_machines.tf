
#---------------------------------------------------------------
# Define Local Variables
#---------------------------------------------------------------

locals {
  vm_prefix = "vm${var.app}${var.environment}linux"
}

#---------------------------------------------------------------
# Create Virtual Machines
#---------------------------------------------------------------

resource "azurerm_public_ip" "pip_vmlinux01" {
  name                = "pip_${local.vm_prefix}01"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  domain_name_label   = "${local.vm_prefix}01"
  sku                 = "Basic"

  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
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

  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_network_interface_application_security_group_association" "asg_dmz_vmlinux01_association" {
  network_interface_id          = azurerm_network_interface.nic_vmlinux01.id
  application_security_group_id = var.asg_hub_js_linux_id
}

resource "tls_private_key" "vmlinux01_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_ssh_public_key" "vmlinux01_ssh_public_key" {
  name                = "vmhubshrlinux01_ssh_public_key"
  location            = var.location
  resource_group_name = var.resource_group_name
  public_key          = tls_private_key.vmlinux01_private_key.public_key_openssh
  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_linux_virtual_machine" "vmlinux01" {
  name                            = "${local.vm_prefix}01"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic_vmlinux01.id]
  size                            = "Standard_B1ms"
  patch_mode                      = "AutomaticByPlatform"
  provision_vm_agent              = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_disk {
    name                 = "${local.vm_prefix}01_OsDisk_1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.vmlinux01_private_key.public_key_openssh
  }

  tags = {
    Environment = var.environment
    Cost_Center = "Apps"
  }
}

#----------------------------------------------------------
# Configure Auto Shutdown
#----------------------------------------------------------

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vmlinux91_auto_shutdown" {
  virtual_machine_id = azurerm_linux_virtual_machine.vmlinux01.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = "1700"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }
}

#----------------------------------------------------------
# Add Extention to Install Database Client Tools
#----------------------------------------------------------

# Commands to Execute To Install is in install_db_tools.sh
# script string is cat install_db_tools.sh | gzip -9 | base64 -w0

resource "azurerm_virtual_machine_extension" "install_dbtools_extension" {
  name                 = "db-tools"
  virtual_machine_id   = azurerm_linux_virtual_machine.vmlinux01.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "H4sIAAAAAAACA62TQWvjMBCF74X+hyEJZPdga7v0UAINBJOlhS0NJD3sKcjSxBaVLUcjrRvYH7+S6mZLYXto6ouMZzT69N7zOPv4c342hodOcoewNjvXc4vh00kDz8/ISwO8c1mFDrID+HRArIxPRL1tyXGtYWXIVRYJCq2wdZ/IPobCYpTD1Qg7pREsdoaUM/YAwrQ7VXnLnTLtbLgo1ZAJmKKoDYwkllA7180YCwLk3cC517mxFet8ydK4WITJF03l1qJGThhm0Nesq2QFDVftCObA0InYyMh4K5ByrcjlksWm9D59Br5tOmNdAn7FSqpqVVvBIx4CaZ+syPZexfUeskRJAbPv+7eYDUrFWdhIbFEUxWXx4yrnJOAPHJ0NReBSwqDZEKGI0HHxyCuECEiz98LwtqIGc//RZCLZm118/8zw3K3Xew0bYzTB6YER3uqjmMPlKW+UsIZCKnNhGvacG+ZL3zrPLq7yb5ess0YmF19kdYj/tbyhY/upggdHl6vNdvnwc3H969j3on3obygq75I8vlVPRpYik/g7Tkghn+JTCtxqsbm5Hk3iMmMmQL/aycqQ4SnM5zC5ub9bsrzkVG/DJeIv9Re8xQV+sQQAAA=="
    }
SETTINGS

  tags = {
    Environment = var.environment
    Cost_Center = "Apps"
  }

}
