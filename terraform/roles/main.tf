//resource "azurerm_role_assignment" "devops-admin" {
//  scope                = data.terraform_remote_state.bastion.outputs.id
//  role_definition_name = "Virtual Machine Administrator Login"
//  principal_id         = var.devops_group_id
//}
//
//resource "azurerm_role_assignment" "devops" {
//  scope                = data.terraform_remote_state.bastion.outputs.bastion_vm_id
//  role_definition_name = "Virtual Machine Administrator Login"
//  principal_id         = var.devops_group_id
//}
resource "azurerm_role_assignment" "devops-aks" {
  scope                = data.terraform_remote_state.aks.outputs.aks_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = var.devops_group_id
}

//resource "azurerm_role_assignment" "developer" {
//  scope                = data.terraform_remote_state.bastion.outputs.bastion_vm_id
//  role_definition_name = "Virtual Machine User Login"
//  principal_id         = var.developer_group_id
//}

resource "azurerm_role_assignment" "developer-aks" {
  scope                = data.terraform_remote_state.aks.outputs.aks_id
  role_definition_name = "Azure Kubernetes Service RBAC Admin"
  principal_id         = var.developer_group_id
}

//resource "azurerm_role_definition" "devops" {
//  role_definition_id = "00000000-0000-0000-0000-000000000000"
//  name               = "my-custom-role-definition"
//  scope              = data.azurerm_subscription.primary.id
//
//  permissions {
//    actions     = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
//    not_actions = []
//  }
//
//  assignable_scopes = [
//    data.azurerm_subscription.primary.id,
//  ]
//}