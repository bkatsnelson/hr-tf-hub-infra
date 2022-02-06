variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "authorized_ip_ranges" {
  type = list(any)
}
