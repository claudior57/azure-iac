//
//output "devops-role-bind" {
//  value = azurerm_role_assignment.devops.id
//}
//
//output "developers-role-bind" {
//  value = azurerm_role_assignment.developer.id
//}
output "devops-role-bind" {
  value = azurerm_role_assignment.devops-aks.id
}

output "developers-role-bind" {
  value = azurerm_role_assignment.developer-aks.id
}
