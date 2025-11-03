# --------------------------------------------------------
# Global Variables for Multi-Environment Deployment
# --------------------------------------------------------

variable "app_name_prefix" {
  type        = string
  description = "Base name prefix used for all Web App and resource names."
}

variable "github_org" {
  type        = string
  description = "GitHub organization name where the repo is located."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name containing the .NET 8 API."
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Key-value tags to apply to all Azure resources."
}

variable "environments" {
  description = "Map of environments with deployment settings (dev, uat, prd)."
  type = map(object({
    location       = string
    appservice_sku = string
    rbac_scope     = optional(string)
  }))
}
