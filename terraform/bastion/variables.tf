variable enviroment {
  default = "staging"
}

variable username {
  default = "admin-staging"
}

variable ssh_public_key {
  default = "../../../.ssh/id_rsa_azurebstn.pub"
}

variable tags {
  type = map
  default = {
    Team        = "DevOps"
    Environment = "Staging"
    CreatedBy   = "Terraform"
  }
}
