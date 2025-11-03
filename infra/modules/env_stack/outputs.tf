# --------------------------------------------------------
# Environment Outputs
# --------------------------------------------------------

output "resource_group_name" {
  value       = module.rg.name
  description = "Resource Group name for this environment."
}

output "resource_group_id" {
  value       = module.rg.id
  description = "Resource Group ID for this environment."
}

output "webapp_name" {
  value       = module.webapp.name
  description = "Azure Web App name for this environment."
}

output "webapp_id" {
  value       = module.webapp.id
  description = "Azure Web App resource ID for this environment."
}

output "azure_client_id" {
  value       = azuread_application.gha.client_id
  description = "Azure AD application (client) ID used by GitHub Actions OIDC."
}
