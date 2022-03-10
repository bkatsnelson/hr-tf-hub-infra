resource "azurerm_subscription" "hub_subscription" {
  alias             = "hub-subscription"
  subscription_name = var.subscription_name
  subscription_id   = var.subscription_id
}
