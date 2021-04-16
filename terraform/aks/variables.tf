variable k8s_sp_id {}
variable k8s_sp_secret {}

variable agent_count {
  default = 3
}

variable ssh_public_key {
  default = "~/.ssh/id_rsa.pub"
}

variable dns_prefix {
  default = "staging"
}

variable cluster_name {
  default = "staging"
}

variable environment {
  default = "stg"
}

variable tags {
  type = map
  default = {
    Team        = "DevOps"
    Environment = "Staging"
    CreatedBy   = "Terraform"
  }
}
