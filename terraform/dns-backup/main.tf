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