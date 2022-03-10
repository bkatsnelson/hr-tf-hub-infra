#----------------------------------------------------------
# Add Management Agent Extention 
#----------------------------------------------------------

resource "azurerm_virtual_machine_extension" "vmlinux01_omsagent" {
  name                       = "omsagent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vmlinux01.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.2"
  auto_upgrade_minor_version = "true"
  settings                   = <<SETTINGS
    {
      "workspaceId": "${var.hub_law_workspace_id}"
    }
SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
   {
      "workspaceKey": "${var.hub_law_primary_shared_key}"
   }
PROTECTED_SETTINGS
}

#----------------------------------------------------------
# Add Guest Configuration Agent Extention 
#----------------------------------------------------------

resource "azurerm_virtual_machine_extension" "vmlinux01_guest_configuration" {
  name                       = "guestconfig"
  virtual_machine_id         = azurerm_linux_virtual_machine.vmlinux01.id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationforLinux"
  type_handler_version       = "1.2"
  auto_upgrade_minor_version = "true"
  automatic_upgrade_enabled  = true
}

#----------------------------------------------------------
# Add Extention to Install Database Client Tools
#----------------------------------------------------------

# Commands to Execute To Install is in install_db_tools.sh
# script string is cat install_db_tools.sh | gzip -9 | base64 -w0

resource "azurerm_virtual_machine_extension" "install_dbtools_extension" {
  name                 = "db-tools"
  virtual_machine_id   = azurerm_linux_virtual_machine.vmlinux01.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "script": "H4sIAAAAAAACA62TQWvjMBCF74X+hyEJZPdga7v0UAINBJOlhS0NJD3sKcjSxBaVLUcjrRvYH7+S6mZLYXto6ouMZzT69N7zOPv4c342hodOcoewNjvXc4vh00kDz8/ISwO8c1mFDrID+HRArIxPRL1tyXGtYWXIVRYJCq2wdZ/IPobCYpTD1Qg7pREsdoaUM/YAwrQ7VXnLnTLtbLgo1ZAJmKKoDYwkllA7180YCwLk3cC517mxFet8ydK4WITJF03l1qJGThhm0Nesq2QFDVftCObA0InYyMh4K5ByrcjlksWm9D59Br5tOmNdAn7FSqpqVVvBIx4CaZ+syPZexfUeskRJAbPv+7eYDUrFWdhIbFEUxWXx4yrnJOAPHJ0NReBSwqDZEKGI0HHxyCuECEiz98LwtqIGc//RZCLZm118/8zw3K3Xew0bYzTB6YER3uqjmMPlKW+UsIZCKnNhGvacG+ZL3zrPLq7yb5ess0YmF19kdYj/tbyhY/upggdHl6vNdvnwc3H969j3on3obygq75I8vlVPRpYik/g7Tkghn+JTCtxqsbm5Hk3iMmMmQL/aycqQ4SnM5zC5ub9bsrzkVG/DJeIv9Re8xQV+sQQAAA=="
    }
SETTINGS

  tags = var.tags

}
