# Example values (edit for your environment)
app_name_prefix = "az305-api"
github_org  = "marcodevopsestudo-cpu"
github_repo = "az305"

common_tags = {
  project = "az305"
  owner   = "estudo.devops"
}

environments = {
  dev = { location = "brazilsouth", appservice_sku = "B1",  rbac_scope = "resource_group" }
  uat = { location = "brazilsouth", appservice_sku = "P1v3" }
  prd = { location = "brazilsouth", appservice_sku = "P1v3" }
}
