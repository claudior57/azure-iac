//resource "azurerm_public_ip" "bastion-host-ip" {
//  name                    = "${var.enviroment}-ip"
//  location                = data.terraform_remote_state.rg.outputs.rg_location
//  resource_group_name     = data.terraform_remote_state.rg.outputs.rg_name
//  allocation_method   = "Static"
//  sku                 = "Standard"
//  tags = var.tags
//}
//
//resource "azurerm_bastion_host" "bastion-host" {
//  name                    = "${var.enviroment}-bastion-host"
//  location                = data.terraform_remote_state.rg.outputs.rg_location
//  resource_group_name     = data.terraform_remote_state.rg.outputs.rg_name
//
//  ip_configuration {
//    name                 = "configuration"
//    subnet_id            = data.terraform_remote_state.vnet.outputs.bastion_subnet_id
//    public_ip_address_id = azurerm_public_ip.bastion-host-ip.id
//  }
//  tags = var.tags
//}