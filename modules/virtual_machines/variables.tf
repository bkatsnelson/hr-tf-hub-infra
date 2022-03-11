variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "app" {
  type = string
}
variable "environment" {
  type = string
}
variable "resource_qualifier" {
  type = string
}
variable "js_linux_subnet_id" {
  type = string
}
variable "asg_hub_js_linux_id" {
  type = string
}
variable "js_windows_subnet_id" {
  type = string
}
variable "asg_hub_js_windows_id" {
  type = string
}
variable "tags" {
  type = map(any)
}
variable "hub_law_workspace_id" {
  type = string
}
variable "hub_law_primary_shared_key" {
  type = string
}
variable "authorized_ip_ranges" {
  type = list(any)
}


