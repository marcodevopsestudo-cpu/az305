output "plan_id" { value = azurerm_service_plan.plan.id }
output "webapp_name" { value = azurerm_linux_web_app.app.name }
output "webapp_default_hostname" { value = azurerm_linux_web_app.app.default_hostname }
output "webapp_id" { value = azurerm_linux_web_app.app.id }
