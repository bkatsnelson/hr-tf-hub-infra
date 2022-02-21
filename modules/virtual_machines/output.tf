output "vmhubshrlinux01_tls_private_key" {
  value     = tls_private_key.vmlinux01_private_key.private_key_pem
  sensitive = true
}
