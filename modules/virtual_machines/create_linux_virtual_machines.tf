
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
}

resource "azurerm_linux_virtual_machine" "vmlinux01" {
  name                            = "${local.vm_prefix}01"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic_vmlinux01.id]
  size                            = "Standard_B1ms"

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "Centos"
    sku       = "7_9"
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
# Configure VMs
#----------------------------------------------------------

resource "azurerm_virtual_machine_extension" "install_postgres_extension" {
  name                 = "postgres-tools"
  virtual_machine_id   = azurerm_linux_virtual_machine.vmlinux01.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm; sudo yum install -y postgresql12-server"
    }
SETTINGS

  tags = {
    Environment = var.environment
    Cost_Center = "Apps"
  }

}

resource "azurerm_virtual_machine_extension" "install_sqlcmd_extension" {
  name                 = "mssql-tools"
  virtual_machine_id   = azurerm_linux_virtual_machine.vmlinux01.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl https://packages.microsoft.com/config/rhel/8/prod.repo > /etc/yum.repos.d/msprod.repo; sudo ACCEPT_EULA=Y yum install -y mssql-tools unixODBC-devel"
    }
SETTINGS

  tags = {
    Environment = var.environment
    Cost_Center = "Apps"
  }

  depends_on = [
    zurerm_virtual_machine_extension.install_postgres_extension
  ]

}

