output "rg_dns_id" {
  value = azurerm_resource_group.rg-dns.id
}

output "dns_public_id" {
  value = azurerm_dns_zone.iac-public
}

output "dns_private_id" {
  value = azurerm_private_dns_zone.iac-private.id
}