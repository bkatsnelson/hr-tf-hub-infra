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
variable "key_vault_subnets" {
  type = list(any)
}
variable "hub_law_id" {
  type = string
}
variable "tags" {
  type = map(any)
}
