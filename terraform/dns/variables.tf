variable resource_group_name {
  default = "dns-resource-group"
}
variable location {
  default = "East US"
}

variable iac_public_name {
  default = "iaclab.com.br"
}

variable iac_private_name {
  default = "iaclab.com.br"
}

variable vnet_link_name {
  default = "staging-private"
}

variable tags {
  type = map
  default = {
    Team        = "DevOps"
    Environment = "DevOps"
    CreatedBy   = "Terraform"
  }
}
