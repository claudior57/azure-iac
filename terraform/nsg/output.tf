output "public_nsg_name" {
  value = azurerm_network_security_group.public_nsg.name
}
output "public_nsg_id" {
  value = azurerm_network_security_group.public_nsg.id
}
output "private_nsg_name" {
  value = azurerm_network_security_group.private_nsg.name
}
output "private_nsg_id" {
  value = azurerm_network_security_group.private_nsg.id
}
output "database_nsg_name" {
  value = azurerm_network_security_group.database_nsg.name
}
output "database_nsg_id" {
  value = azurerm_network_security_group.database_nsg.id
}
//output "bastion_nsg_id" {
//  value = azurerm_network_security_group.bastion_nsg.id
//}