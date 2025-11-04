output "resource_group" {
  value = module.rg.name
}

output "webapp_name" {
  value = module.app.webapp_name
}

output "webapp_hostname" {
  value = module.app.webapp_default_hostname
}

output "azuread_app_client_id" {
  value       = module.oidc.app_client_id
  description = "Use como AZURE_CLIENT_ID no GitHub"
}

data "azurerm_subscription" "current" {}
output "tenant_id" {
  value       = data.azurerm_subscription.current.tenant_id
  description = "AZURE_TENANT_ID"
}
output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "AZURE_SUBSCRIPTION_ID"
}
