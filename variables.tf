variable "location" {
  type = string
}
variable "address_space_map" {
  type = map(any)
  default = {
    eastus = ["10.130.0.0/16", "10.131.0.0/16"]
  }
}
variable "authorized_ip_ranges" {
  type    = list(any)
  default = ["47.19.117.0/24"]
}
variable "smbc_hub_domain" {
  type    = string
  default = "hub.smbcgroup.azure.com"
}
