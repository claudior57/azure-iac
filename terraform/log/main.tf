resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "log" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
  sku                 = var.log_analytics_workspace_sku

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "log" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.log.location
  resource_group_name   = data.terraform_remote_state.rg.outputs.rg_name
  workspace_resource_id = azurerm_log_analytics_workspace.log.id
  workspace_name        = azurerm_log_analytics_workspace.log.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
