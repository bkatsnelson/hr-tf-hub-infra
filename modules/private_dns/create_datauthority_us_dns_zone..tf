resource "azurerm_dns_zone" "dns-datauthority-us" {
  name                = "datauthority.us"
  resource_group_name = var.resource_group_name
}