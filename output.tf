output "rg_hub_infra_name" {
  value = module.resource_groups.rg_hub_infra_name
}
output "vmhubshrlinux01_tls_private_key" {
  value     = module.virtual_machines.vmhubshrlinux01_tls_private_key
  sensitive = true
}
output "hub_infra_vnet_id" {
  value = module.hub_infra_vnet.hub_infra_vnet_id
}
output "hub_infra_vnet_name" {
  value = module.hub_infra_vnet.hub_infra_vnet_name
}
output "loc_acronym_map" {
  value = var.loc_acronym_map
}
output "hub_address_space_map" {
  value = var.address_space_map
}
output "asg_hub_js_linux_id" {
  value = module.application_security_groups.asg_hub_js_linux_id
}
output "asg_hub_js_windows_id" {
  value = module.application_security_groups.asg_hub_js_windows_id
}
output "company" {
  value = var.company
}
