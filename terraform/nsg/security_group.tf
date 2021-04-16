resource "azurerm_network_security_group" "private_nsg" {
  name                = "private-nsg"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "database_nsg" {
  name                = "database-nsg"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "public_nsg" {
  name                = "public-nsg"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
  tags                = var.tags
}

//resource "azurerm_network_security_group" "bastion_nsg" {
//  name                = "bastion-nsg"
//  location            = data.terraform_remote_state.rg.outputs.rg_location
//  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
//  tags                = var.tags
//}