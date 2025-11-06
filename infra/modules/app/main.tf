
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
  https_only                    = true
  public_network_access_enabled = false
  client_affinity_enabled       = false
  tags                          = var.tags

  identity { type = "SystemAssigned" }

  site_config {
    ftps_state             = "Disabled"
    always_on              = true
    vnet_route_all_enabled = true

    # ✅ Correct fields for containers on azurerm v4
    application_stack {
      docker_image_name = "${var.login_server}/${var.image_repo}"
    }

    # ✅ Use MI to pull from ACR
    container_registry_use_managed_identity = true
  }

  virtual_network_subnet_id = var.vnet_integration_subnet_id

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = var.container_port
  }
}

# ✅ Give the web app MI the AcrPull role AFTER the web app exists
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}