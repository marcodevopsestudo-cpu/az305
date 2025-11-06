output "ACR_NAME" {
  value = module.acr.acr_name
}


output "AZURE_CLIENT_ID" {
  value = module.oidc.app_client_id
}

output "RG" {
  value = module.rg.name
}

output "login_server" { value = module.acr.login_server }