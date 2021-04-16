variable enviroment {
  default = "Staging"
}

variable tags {
  type = map
  default = {
    Team                   = "DevOps"
    Environment            = "Staging"
    CreatedBy              = "Terraform"
    Managed-by-k8s-ingress = "True"
  }
}
