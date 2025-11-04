variable "scope_id" { type = string }            # RG or subscription scope
variable "principal_object_id" { type = string } # SP objectId
variable "role_definition_name" {
  type    = string
  default = "Contributor"
}
