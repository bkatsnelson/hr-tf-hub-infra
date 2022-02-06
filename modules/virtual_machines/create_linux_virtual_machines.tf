
#---------------------------------------------------------------
# Create Virtual Machines
#---------------------------------------------------------------

resource "azurerm_public_ip" "dblabnvadv01_pip" {
  name                = "dblabnvadv01-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  domain_name_label   = "dblabnvadv01-hub"

  tags = {
    Environment = "Hub"
    Cost_Center = "Network"
  }
}

resource "azurerm_network_interface" "dblabnvadv01_nic" {
  name                = "dblabnvadv01"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.dmz_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_security_group_association" "asg_dmz_dblabnvadv01_association" {
  network_interface_id          = azurerm_network_interface.dblabnvadv01_nic.id
  application_security_group_id = var.asg_dmz_id
}

resource "tls_private_key" "dblabnvav01_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
