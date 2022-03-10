
#-----------------------------------------------------------------------
# Define Terraform Input Variables
#-----------------------------------------------------------------------

variable "subscription_name" {
  type    = string
  default = "SMBCGROUP Human Resources"
}
variable "subscription_id" {
  type    = string
  default = "c15bb9c5-2f4d-4112-b6d0-aa2434d885c9"
}
variable "tenant_id" {
  type    = string
  default = "c7f6413d-1e73-45d2-b0da-a68713b515a7"
}
variable "location" {
  type = string
}
variable "company" {
  type    = string
  default = "smbc"
}
variable "app" {
  type = string
}
variable "environment" {
  type = string
}
variable "cost_center" {
  type    = string
  default = "Network"
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
    eastus  = ["10.197.0.0/17", "10.198.0.0/17"]
    eastus2 = ["10.199.0.0/17", "10.200.0.0/17"]
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
