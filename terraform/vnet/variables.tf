variable enviroment {
  default = "Staging"
}

variable vnet_cidr {
  default = ["10.1.0.0/16"]
}

variable public_subnet_address_prefix {
  default = "10.1.16.0/20"
}

variable private_subnet_address_prefix {
  default = "10.1.32.0/20"
}

variable database_subnet_address_prefix {
  default = "10.1.48.0/20"
}

variable bastion_subnet_address_prefix {
  default = "10.1.64.0/20"
}


variable tags {
  type = map
  default = {
    Team        = "DevOps"
    Environment = "Staging"
    CreatedBy   = "Terraform"
  }
}
