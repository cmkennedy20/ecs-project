provider "aws" {
  region     = var.TF_VAR_region
  access_key = var.TF_VAR_access_key
  secret_key = var.TF_VAR_private_key
}
