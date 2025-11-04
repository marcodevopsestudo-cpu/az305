resource "azuread_application" "app" {
  display_name = "${var.name_prefix}-gha-oidc"
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.client_id
}

resource "azuread_application_federated_identity_credential" "fic" {
  for_each       = toset(var.oidc_subjects)
  application_id = azuread_application.app.id

  # Prefixa com "gha-" e troca qualquer caractere inválido por "-"
  display_name = replace(replace("gha-${each.value}", ":", "-"), "/", "-")
  issuer       = "https://token.actions.githubusercontent.com"
  audiences    = ["api://AzureADTokenExchange"]

  # o subject continua exatamente como o GitHub emite
  subject = each.value

  description = "OIDC GitHub Actions"
}
