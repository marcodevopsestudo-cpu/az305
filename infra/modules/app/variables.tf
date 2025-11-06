variable "name_prefix" { type = string }
variable "location" { type = string }
variable "login_server" { type = string }
variable "acr_id" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "plan_sku_name" { type = string }
variable "vnet_integration_subnet_id" { type = string }
#############################
# Container image settings  #
#############################

# Repository name inside your ACR (e.g., 'myapi')
variable "image_repo" {
  description = "The ACR repository name that contains your image (for example, 'myapi')"
  type        = string
}

# Image tag to deploy (for example, 'latest' or 'sha-abc123')
variable "image_tag" {
  description = "The image tag to pull from ACR (for example, 'latest' or a specific SHA)"
  type        = string
  default     = "latest"
}

# The TCP port that your container listens on (for example, 80 or 8080)
variable "container_port" {
  description = "Port on which the containerized application listens inside the container"
  type        = string
  default     = "8080"
}