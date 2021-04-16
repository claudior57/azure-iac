provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.23.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "devops-acmecoorp"
    storage_account_name = "devopsacmecoorpstg"
    container_name       = "acmecoorp-iac"
    key                  = "staging/gateway.tfstate"
  }
}

data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "devops-acmecoorp"
    storage_account_name = "devopsacmecoorpstg"
    container_name       = "acmecoorp-iac"
    key                  = "staging/rg.tfstate"
  }
}

data "terraform_remote_state" "log" {
  backend = "azurerm"
  config = {
    resource_group_name  = "devops-acmecoorp"
    storage_account_name = "devopsacmecoorpstg"
    container_name       = "acmecoorp-iac"
    key                  = "staging/log.tfstate"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "devops-acmecoorp"
    storage_account_name = "devopsacmecoorpstg"
    container_name       = "acmecoorp-iac"
    key                  = "staging/vnet.tfstate"
  }
}