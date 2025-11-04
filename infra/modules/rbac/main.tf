resource "azurerm_role_assignment" "assign" {
  scope                = var.scope_id
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_object_id
}
