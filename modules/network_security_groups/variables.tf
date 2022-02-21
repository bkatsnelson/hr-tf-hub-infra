variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "authorized_ip_ranges" {
  type = list(any)
}
variable "asg_hub_js_linux_id" {
  type = string
}
variable "asg_hub_js_windows_id" {
  type = string
}
