variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "address_space" {
  type = list(any)
}
variable "nsg_dmz_id" {
  type = string
}
variable "nsg_mgmt_id" {
  type = string
}
variable "nsg_storage_accounts_id" {
  type = string
}
variable "hub_vnet_disable_spoke_route_table_id" {
  type = string
}
