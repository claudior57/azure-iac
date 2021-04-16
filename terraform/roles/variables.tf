variable "developer_group_id" {}

variable "devops_group_id" {}

variable tags {
  type = map
  default = {
    Team        = "DevOps"
    Environment = "Staging"
    CreatedBy   = "Terraform"
  }
}