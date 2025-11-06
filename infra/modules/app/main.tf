
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

  # Required for ACR pulls via MI
  identity { type = "SystemAssigned" }

  site_config {
    ftps_state             = "Disabled"
    always_on              = true
    vnet_route_all_enabled = true

    # ✅ Correct attribute names
    application_stack {
      docker_image_name = "${var.login_server}/${var.image_repo}"  # e.g. myacr.azurecr.io/myapi
                                # e.g. "latest" or SHA
    }

    # Use Managed Identity to pull from ACR
    container_registry_use_managed_identity = true
    # If you use a User Assigned MI, also set:
    # container_registry_managed_identity_client_id = azurerm_user_assigned_identity.uai.client_id
  }
    # If you were using a **User Assigned** identity, set: 
    # container_registry_managed_identity_client_id = azurerm_user_assigned_identity.uai.client_id
}

# Grant AcrPull to this web app's managed identity
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id              # module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}