variable "subscription_id" { type = string }
variable "tenant_id"       { type = string }

variable "prefix"   { 
  type = string  
  default = "az305-api" 
  }
variable "location" { 
  type = string 
   default = "brazilsouth" 
   }

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.20.0.0/16"]
}

# Only CIDRs; rules are defined inline in main.tf for clarity
variable "subnets_cidrs" {
  type = object({
    app  = string
    data = string
    pe   = string
  })
  default = {
    app  = "10.20.1.0/24"
    data = "10.20.2.0/24"
    pe   = "10.20.3.0/24"
  }
}

variable "plan_sku_name" {
  type    = string
  default = "S1"
}

variable "github_owner"  { type = string }
variable "github_repo"   { type = string }
variable "github_branch" {
   type = string  
   default = "main" 
   }

# Optional: allow multiple OIDC subjects (branch and/or environments)
variable "oidc_subjects" {
  type    = list(string)
  default = []
}
