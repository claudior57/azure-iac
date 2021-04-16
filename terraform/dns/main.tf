resource "azurerm_resource_group" "rg-dns" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_dns_zone" "iac-public" {
  name                = var.iac_public_name
  resource_group_name = azurerm_resource_group.rg-dns.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "iac-private" {
  name                = var.iac_private_name
  resource_group_name = azurerm_resource_group.rg-dns.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns" {
  name                  = var.vnet_link_name
  resource_group_name   = azurerm_resource_group.rg-dns.name
  private_dns_zone_name = azurerm_private_dns_zone.iac-private.name
  virtual_network_id    = data.terraform_remote_state.vnet.outputs.vnet_id
}