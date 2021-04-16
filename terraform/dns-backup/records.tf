resource "azurerm_dns_a_record" "drone" {
  name                = "drone"
  zone_name           = azurerm_dns_zone.iac-public.name
  resource_group_name = azurerm_resource_group.rg-dns.name
  ttl                 = 300
  target_resource_id  = "TBD"
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