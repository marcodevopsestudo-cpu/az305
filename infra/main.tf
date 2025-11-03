# --------------------------------------------------------
# Root Orchestrator (main.tf)
# --------------------------------------------------------
# Orchestrates dev/uat/prd by calling the env_stack module with for_each.
# Configures providers and aggregates outputs for GitHub Environments.
# --------------------------------------------------------

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.114" }
    azuread = { source = "hashicorp/azuread", version = "~> 2.50" }
  }
}

provider "azurerm" { 
  features {} 
  }
provider "azuread" {}

data "azurerm_client_config" "current" {}
data "azurerm_subscription"  "current" {}

module "env" {
  source  = "./modules/env_stack"
  for_each = var.environments

  location         = each.value.location
  app_name_prefix  = var.app_name_prefix
  env_name         = each.key
  appservice_sku   = each.value.appservice_sku
  tags             = merge(var.common_tags, { env = each.key })

  github_org       = var.github_org
  github_repo      = var.github_repo
  github_subject   = "repo:${var.github_org}/${var.github_repo}:environment:${each.key}"
  github_repo_ref  = each.key

  rbac_scope       = coalesce(each.value.rbac_scope, "resource_group")
}

output "env_webapp_names" {
  value       = { for k, m in module.env : k => m.webapp_name }
  description = "Map of environment names to Web App names."
}

output "env_rg_names" {
  value       = { for k, m in module.env : k => m.resource_group_name }
  description = "Map of environment names to Resource Group names."
}

output "azure_tenant_id" {
  value       = data.azurerm_client_config.current.tenant_id
  description = "Tenant ID for Azure login in GitHub."
}

output "azure_subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "Subscription ID for Azure login in GitHub."
}

output "env_azure_client_ids" {
  value       = { for k, m in module.env : k => m.azure_client_id }
  description = "Map env -> Azure AD application client ID (OIDC)."
}
