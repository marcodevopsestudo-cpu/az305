# --------------------------------------------------------
# Resource Group Module Variables
# --------------------------------------------------------

variable "name" {
  type        = string
  description = "Name of the Azure Resource Group."
}

variable "location" {
  type        = string
  description = "Azure region where the Resource Group will be created."
}

variable "tags" {
  type        = map(string)
  description = "Key-value tags to apply to the Resource Group."
}
