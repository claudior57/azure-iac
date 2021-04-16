######################################
#     Public NetworkSecurityGroup
######################################
resource "azurerm_network_security_rule" "public-allow-all-outbound" {
  name                        = "public-allow-all-outbound"
  description                 = "Allow Traffic to outside the public network"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}

resource "azurerm_network_security_rule" "public-allow-all-http-inbound" {
  name                        = "public-allow-all-http-inbound"
  description                 = "Allow inbound traffic from internet"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}

resource "azurerm_network_security_rule" "public-allow-all-https-inbound" {
  name                        = "public-allow-all-https-inbound"
  description                 = "Allow inbound traffic from internet"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}

######################################
#     Private NetworkSecurityGroup
######################################
resource "azurerm_network_security_rule" "private-allow-all-outbound" {
  name                        = "private-allow-all-outbound"
  description                 = "Allow Traffic to outside the private network"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.private_nsg.name
}

resource "azurerm_network_security_rule" "private-allow-inbound-my-home" {
  name                        = "private-allow-inbound-my-home"
  description                 = "Allow inbound traffic from My Home IP"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "2804:14c:5bb3:9505:9dbf:fee9:f76d:d84a"
  destination_address_prefix  = "*"
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.private_nsg.name
}

######################################
#     Database NetworkSecurityGroup
######################################
resource "azurerm_network_security_rule" "database-allow-all-outbound" {
  name                        = "database-allow-all-outbound"
  description                 = "Allow Traffic to outside the database network"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.database_nsg.name
}

resource "azurerm_network_security_rule" "database-allow-inbound-my-home" {
  name                        = "database-allow-inbound-my-home"
  description                 = "Allow inbound traffic from My Home IP"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "2804:14c:5bb3:9505:9dbf:fee9:f76d:d84a"
  destination_address_prefix  = "*"
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.database_nsg.name
}

######################################
#     Database NetworkSecurityGroup
######################################
//
//resource "azurerm_network_security_rule" "bastion-allow-all-outbound" {
//  name                        = "bastion-allow-all-outbound"
//  description                 = "Allow Traffic to outside the bastion network"
//  priority                    = 100
//  direction                   = "Outbound"
//  access                      = "Allow"
//  protocol                    = "*"
//  source_port_range           = "*"
//  destination_port_range      = "*"
//  source_address_prefix       = "*"
//  destination_address_prefix  = "0.0.0.0/0"
//  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
//  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
//}

//resource "azurerm_network_security_rule" "bastion-allow-inbound-my-home" {
//  name                        = "bastion-allow-inbound-my-home"
//  description                 = "Allow inbound traffic from My Home IP"
//  priority                    = 103
//  direction                   = "Inbound"
//  access                      = "Allow"
//  protocol                    = "Tcp"
//  source_port_range           = "*"
//  destination_port_range      = "*"
//  source_address_prefix       = "2804:14c:5bb3:9505:9dbf:fee9:f76d:d84a"
//  destination_address_prefix  = "*"
//  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
//  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
//}
//
//
//resource "azurerm_network_security_rule" "bastion-allow-inbound-gateway-manager" {
//  name                        = "bastion-allow-inbound-gateway-manager"
//  description                 = "Allow inbound traffic from azure gateway manager"
//  priority                    = 104
//  direction                   = "Inbound"
//  access                      = "Allow"
//  protocol                    = "Tcp"
//  source_port_range           = "*"
//  destination_port_range      = "*"
//  source_address_prefix       = "GatewayManager"
//  destination_address_prefix  = "*"
//  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
//  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
//}