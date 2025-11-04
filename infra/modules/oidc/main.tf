resource "azuread_application" "app" {
  display_name = "${var.name_prefix}-gha-oidc"
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.client_id
}

# Remove caracteres inválidos substituindo por "-"
resource "azuread_application_federated_identity_credential" "fic" {
  for_each              = toset(var.oidc_subjects)
  application_id = azuread_application.app.id

  # Replace step by step — remove ":" "/" e espaços
  display_name = replace(
    replace(
      replace(
        replace("gha-${each.value}", ":", "-"),
      "/", "-"),
    " ", "-"),
  "_", "-")

  issuer    = "https://token.actions.githubusercontent.com"
  audiences = ["api://AzureADTokenExchange"]
  subject   = each.value
  description = "OIDC GitHub Actions"
}
