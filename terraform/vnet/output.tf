output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "vnet_subnet" {
  value = azurerm_virtual_network.vnet.subnet
}
output "private_subnet_id" {
  value = element([
    for subnet in azurerm_virtual_network.vnet.subnet :
    subnet.id
    if subnet.name == "PrivateSubnet"
  ], 0)
}
output "public_subnet_id" {
  value = element([
    for subnet in azurerm_virtual_network.vnet.subnet :
    subnet.id
    if subnet.name == "PublicSubnet"
  ], 0)
}