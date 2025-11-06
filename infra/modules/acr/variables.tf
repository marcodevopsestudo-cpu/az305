variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "acr_name"            { type = string }
variable "tags" {type = map(string)}
  
# Leave blank if you DON'T know it yet (you'll assign later)
variable "webapp_principal_id" {
  type    = string
  default = ""
}