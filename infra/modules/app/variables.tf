variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "plan_sku_name" { type = string }
variable "vnet_integration_subnet_id" { type = string }
