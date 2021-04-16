resource "azurerm_kubernetes_cluster" "aks-main" {
  name                    = var.cluster_name
  location                = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name     = data.terraform_remote_state.rg.outputs.rg_name
  dns_prefix              = var.dns_prefix
  private_cluster_enabled = false

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  role_based_access_control {
    enabled = true
  }

  default_node_pool {
    name                = "${var.environment}mainpool"
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = true
    availability_zones  = [1, 2, 3]
    node_count          = 1
    min_count           = 1
    max_count           = 5
    vnet_subnet_id      = data.terraform_remote_state.vnet.outputs.private_subnet_id
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id = var.k8s_sp_id
    client_secret = var.k8s_sp_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = data.terraform_remote_state.log.outputs.log_id
    }

    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }
  }

  tags = var.tags

}

resource "azurerm_kubernetes_cluster_node_pool" "secondary-nodepool" {
  name                  = "${var.environment}secpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-main.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  min_count             = 1
  enable_auto_scaling   = true
  max_count             = 5
  availability_zones    = [1, 2, 3]
  tags                  = var.tags
  vnet_subnet_id        = data.terraform_remote_state.vnet.outputs.private_subnet_id
}