variable "name_prefix" { type = string }
variable "github_owner" { type = string }
variable "github_repo" { type = string }
variable "github_branch" { type = string }
variable "oidc_subjects" {
  type = list(string)
}
