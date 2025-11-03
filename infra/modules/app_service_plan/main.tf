# --------------------------------------------------------
# App Service Plan (Linux)
# --------------------------------------------------------

resource "azurerm_service_plan" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = split("/resourceGroups/", var.resource_group_id)[1]
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

output "id"   { value = azurerm_service_plan.this.id }
output "name" { value = azurerm_service_plan.this.name }
