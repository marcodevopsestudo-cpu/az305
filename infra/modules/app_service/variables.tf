# --------------------------------------------------------
# Web App Module Variables
# --------------------------------------------------------

variable "name" {
  type        = string
  description = "Globally-unique name of the Azure Web App."
}

variable "location" {
  type        = string
  description = "Azure region where the Web App will be created."
}

variable "resource_group_id" {
  type        = string
  description = "Resource Group ID where the Web App resides."
}

variable "service_plan_id" {
  type        = string
  description = "ID of the App Service Plan used by the Web App."
}

variable "app_settings" {
  type        = map(string)
  description = "Application settings (environment variables) for the Web App."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the Web App."
}
