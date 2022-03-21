variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "resource_qualifier" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "authorized_ip_ranges" {
  type = list(any)
}
variable "hub_law_id" {
  type = string
}
variable "hub_diag_storage_id" {
  type = string
}
variable "key_vault_subnet_id" {
  type = string
}
variable "hub_key_vaukt_private_dns_id" {
  type = string
}
variable "tags" {
  type = map(any)
}
