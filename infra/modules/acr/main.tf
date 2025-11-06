resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}
resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium" # or Standard
  admin_enabled       = false
  tags                = var.tags
}

