# --------------------------------------------------------
# Root Outputs (Convenience)
# --------------------------------------------------------

output "env_urls" {
  value       = { for k, m in module.env : k => "https://${m.webapp_name}.azurewebsites.net" }
  description = "Map of environment names to public Web App URLs."
}
