resource "azurerm_container_registry" "acr-main" {
  name                     = "acr${var.enviroment}"
  location                 = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name      = data.terraform_remote_state.rg.outputs.rg_name
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["West US"]
  tags                     = var.tags

//  service_principal {
//    client_id     = azuread_service_principal.aks_sp.application_id
//    client_secret = random_string.aks_sp_password.result
//  }
}


