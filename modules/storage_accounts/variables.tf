variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "resource_qualifier" {
  type = string
}
variable "hub_blob_private_dns_id" {
  type = string
}
variable "storage_accounts_subnet_id" {
  type = string
}
variable "authorized_ip_ranges" {
  type = list(any)
}
variable "tags" {
  type = map(any)
}
