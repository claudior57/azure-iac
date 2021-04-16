
//Very Expensive stuff dont uncomment
//
//resource "azurerm_network_ddos_protection_plan" "staging" {
//  name                = "ddosStagingPlan1"
//  location            = data.terraform_remote_state.rg.outputs.rg_location
//  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
//}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.enviroment}Network"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
  address_space       = var.vnet_cidr
  subnet {
    name           = "PublicSubnet"
    address_prefix = var.public_subnet_address_prefix
    security_group = data.terraform_remote_state.nsg.outputs.public_nsg_id
  }
  subnet {
    name           = "PrivateSubnet"
    address_prefix = var.private_subnet_address_prefix
    security_group = data.terraform_remote_state.nsg.outputs.private_nsg_id
  }
  subnet {
    name           = "DatabaseSubnet"
    address_prefix = var.database_subnet_address_prefix
    security_group = data.terraform_remote_state.nsg.outputs.database_nsg_id
  }
  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = var.bastion_subnet_address_prefix
    //    security_group = data.terraform_remote_state.nsg.outputs.bastion_nsg_id
  }
  tags = var.tags
}
