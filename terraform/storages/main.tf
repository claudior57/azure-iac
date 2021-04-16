resource "random_id" "random_id" {
  keepers = {

    # Generate a new ID only when a new resource group is defined.
    resource_group = data.terraform_remote_state.rg.outputs.rg_name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics.
resource "azurerm_storage_account" "storage_account" {
  name                     = "storage-${random_id.random_id.hex}"
  resource_group_name      = data.terraform_remote_state.rg.outputs.rg_name
  location                 = data.terraform_remote_state.rg.outputs.rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags

}