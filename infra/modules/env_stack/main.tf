# --------------------------------------------------------
# Environment Stack (RG, Plan, WebApp, OIDC, RBAC)
# --------------------------------------------------------

locals {
  rg_name     = "${var.app_name_prefix}-${var.env_name}-rg"
  plan_name   = "${var.app_name_prefix}-${var.env_name}-plan"
  webapp_name = "${var.app_name_prefix}-${var.env_name}"
}

module "rg" {
  source   = "../rg"
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

module "plan" {
  source            = "../app_service_plan"
  name              = local.plan_name
  location          = var.location
  resource_group_id = module.rg.id
  sku_name          = var.appservice_sku
  tags              = var.tags
}

module "webapp" {
  source            = "../app_service"
  name              = local.webapp_name
  location          = var.location
  resource_group_id = module.rg.id
  service_plan_id   = module.plan.id
  tags              = var.tags

  app_settings = {
    ASPNETCORE_ENVIRONMENT              = upper(var.env_name)
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }
}

# OIDC: one Entra ID app per env, bound to GH environment via federated credential
resource "azuread_application" "gha" {
  display_name = "${local.webapp_name}-gha"
}

resource "azuread_service_principal" "gha" {
  client_id = azuread_application.gha.client_id
}

resource "azuread_application_federated_identity_credential" "gha" {
  display_name   = "github-${var.github_repo_ref}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = var.github_subject
  application_id = azuread_application.gha.id
}

locals {
  rbac_scope_id = var.rbac_scope == "webapp" ? module.webapp.id : module.rg.id
}

resource "azurerm_role_assignment" "gha_contributor" {
  scope                = local.rbac_scope_id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.gha.object_id
}
