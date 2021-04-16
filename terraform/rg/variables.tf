variable resource_group_name {
  default = "staging"
}
variable location {
  default = "East US"
}

variable tags {
  type = map
  default = {
    Team        = "DevOps"
    Environment = "Staging"
    CreatedBy   = "Terraform"
  }
}
