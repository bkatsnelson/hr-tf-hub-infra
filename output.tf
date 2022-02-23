output "rg_hub_infra_name" {
  value = module.resource_groups.rg_hub_infra_name
}
output "vmhubshrlinux01_tls_private_key" {
  value     = module.virtual_machines.vmhubshrlinux01_tls_private_key
  sensitive = true
}

