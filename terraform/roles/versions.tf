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
    key                  = "staging/roles.tfstate"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "azurerm"
  config = {
    resource_group_name  = "devops-acmecoorp"
    storage_account_name = "devopsacmecoorpstg"
    container_name       = "acmecoorp-iac"
    key                  = "staging/bastion.tfstate"

  }
}

data "terraform_remote_state" "aks" {
  backend = "azurerm"
  config = {
    resource_group_name  = "devops-acmecoorp"
    storage_account_name = "devopsacmecoorpstg"
    container_name       = "acmecoorp-iac"
    key                  = "staging/aks.tfstate"

  }
}