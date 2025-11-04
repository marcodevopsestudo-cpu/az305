resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-asp-linux"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = var.plan_sku_name
  tags     = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.name_prefix}-webapi"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on              = true
    vnet_route_all_enabled = true

    application_stack {
      dotnet_version = "8.0"
    }
  }

  virtual_network_subnet_id = var.vnet_integration_subnet_id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
    "ASPNETCORE_ENVIRONMENT"   = "Development"
  }

  identity { type = "SystemAssigned" }
}
