output "app_client_id" {
  value = azuread_application.app.client_id
}

output "service_principal_object_id" {
  value = azuread_service_principal.sp.object_id
}


 