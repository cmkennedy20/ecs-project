variable "TF_VAR_access_key" {
  type        = string
  description = "The AWS access key"
}
variable "TF_VAR_private_key" {
  type        = string
  description = "The AWS private key"
}

variable "TF_VAR_region" {
  type        = string
  description = "The AWS Region"
  default     = "us-east-1"
}

variable "TF_VAR_machine_type" {
  type        = string
  description = "The AMI image type"
  default     = "amazon-linux-2"
}

variable "TF_VAR_azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "TF_VAR_ecr_repo" {
  type        = string
  description = "The ECR Repo path"
}