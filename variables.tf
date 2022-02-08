variable "location" {
  type    = string
  default = "eastus"
}
variable "app" {
  type    = string
  default = "hub"
}
variable "environment" {
  type    = string
  default = "hub"
}
variable "loc_acronym_map" {
  type = map(any)
  default = {
    eastus    = "use",
    eastus2   = "use2",
    uscentral = "uscn"
  }
}
variable "address_space_map" {
  type = map(any)
  default = {
    eastus = ["10.200.0.0/17", "10.201.0.0/17"]
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
