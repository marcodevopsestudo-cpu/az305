# --------------------------------------------------------
# Azure Linux Web App (.NET 8)
# --------------------------------------------------------

resource "azurerm_linux_web_app" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = split("/resourceGroups/", var.resource_group_id)[1]
  service_plan_id     = var.service_plan_id
  https_only          = true
  tags                = var.tags

  site_config {
    ftps_state = "Disabled"
    always_on  = true

    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = var.app_settings
}

output "id" { value = azurerm_linux_web_app.this.id }
output "name" { value = azurerm_linux_web_app.this.name }
