# --------------------------------------------------------
# Environment Stack Module Variables
# --------------------------------------------------------

variable "location" {
  type        = string
  description = "Azure region where resources for this environment will be created."
}

variable "env_name" {
  type        = string
  description = "Logical environment name (dev, uat, prd)."
}

variable "app_name_prefix" {
  type        = string
  description = "Base name prefix used for all resources in this environment."
}

variable "appservice_sku" {
  type        = string
  description = "SKU tier for the App Service Plan (e.g., B1, P1v3)."
}

variable "tags" {
  type        = map(string)
  description = "Key-value tags assigned to all resources in this environment."
}

variable "github_org" {
  type        = string
  description = "GitHub organization name hosting the repository."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name that triggers deployments."
}

variable "github_subject" {
  type        = string
  description = "OIDC subject used to trust GitHub Actions with Entra ID."
}

variable "github_repo_ref" {
  type        = string
  description = "Label for the GitHub ref/environment (dev/uat/prd) used in display names."
}

variable "rbac_scope" {
  type        = string
  default     = "resource_group"
  description = "RBAC scope for GitHub Actions: 'resource_group' or 'webapp'."
}
