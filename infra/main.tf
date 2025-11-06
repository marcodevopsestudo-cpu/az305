

locals{
  acr_name                   = "${var.prefix}acr"
  rg_name                    = "${var.prefix}-rg"
}
########################################
# Resource Group
########################################
module "rg" {
  source   = "./modules/rg"
  location = var.location
  tags     = var.tags
  name     = local.rg_name
}
########################################
# NETWORKING (for_each: VNet + Subnets + NSGs)
########################################
module "networking" {
  source              = "./modules/networking"
  name_prefix         = var.prefix
  location            = var.location
  resource_group_name = module.rg.name
  tags                = var.tags

  vnet_address_space = var.vnet_address_space

  subnets = {
    "app-snet" = {
      cidr                                 = var.subnets_cidrs.app
      delegate_to_appservice               = true
      enable_private_endpoint_policies     = false
      enable_private_link_service_policies = false

      nsg_rules = {
        AllowOutboundInternet = {
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "Internet"
        }
      }
    }

    "data-snet" = {
      cidr                                 = var.subnets_cidrs.data
      delegate_to_appservice               = false
      enable_private_endpoint_policies     = false
      enable_private_link_service_policies = false

      nsg_rules = {
        DenyAllInbound = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      }
    }

    "privatelink-snet" = {
      cidr                                 = var.subnets_cidrs.pe
      delegate_to_appservice               = false
      enable_private_endpoint_policies     = true
      enable_private_link_service_policies = true

      nsg_rules = {
        AllowVNetOutbound = {
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
        }
      }
    }
  }
}

module "acr" {
  source                     = "./modules/acr"
  acr_name                   = local.acr_name
  location                   = var.location
  resource_group_name        = local.rg_name
  webapp_principal_id        = module.app.webapp_id
  tags                       = var.tags
}

########################################
# APP (App Service Plan + Web App .NET 8)
########################################
module "app" {
  source                     = "./modules/app"
  name_prefix                = var.prefix
  location                   = var.location
  resource_group_name        = module.rg.name
  tags                       = var.tags
  plan_sku_name              = var.plan_sku_name
  vnet_integration_subnet_id = module.networking.subnet_ids["app-snet"]
  image_repo = var.image_repo
  login_server = module.acr.login_server
  acr_id = module.acr.acr_id
}



########################################
# OIDC (App Registration + Federated Credential)
########################################
# Provide default OIDC subjects if none passed (branch main + environment dev)
locals {
  default_oidc_subjects = [
    "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/${var.github_branch}",
    "repo:${var.github_owner}/${var.github_repo}:environment:dev"
  ]

  effective_oidc_subjects = length(var.oidc_subjects) > 0 ? var.oidc_subjects : local.default_oidc_subjects
}

module "oidc" {
  source        = "./modules/oidc"
  name_prefix   = var.prefix
  github_owner  = var.github_owner
  github_repo   = var.github_repo
  github_branch = var.github_branch
  oidc_subjects = local.effective_oidc_subjects
}

########################################
# RBAC (Contributor no RG para o SP do OIDC)
########################################
module "rbac" {
  source               = "./modules/rbac"
  scope_id             = module.rg.id
  principal_object_id  = module.oidc.service_principal_object_id
  role_definition_name = "Contributor"
  depends_on = [module.oidc]
}
