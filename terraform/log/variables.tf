variable enviroment {
  default = "Staging"
}

variable log_analytics_workspace_name {
  default = "staging"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
  default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable log_analytics_workspace_sku {
  default = "PerGB2018"
}

variable tags {
  type = map
  default = {
    Team        = "DevOps"
    Environment = "Staging"
    CreatedBy   = "Terraform"
  }
}
