# --------------------------------------------------------
# App Service Plan Module Variables
# --------------------------------------------------------

variable "name" {
  type        = string
  description = "Name of the App Service Plan."
}

variable "location" {
  type        = string
  description = "Azure region where the App Service Plan will be created."
}

variable "resource_group_id" {
  type        = string
  description = "Resource Group ID where the App Service Plan resides."
}

variable "sku_name" {
  type        = string
  description = "SKU tier for the App Service Plan (e.g., B1, P1v3)."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the App Service Plan."
}
