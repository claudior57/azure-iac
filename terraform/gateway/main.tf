locals {
  backend_address_pool_name      = "${data.terraform_remote_state.vnet.outputs.vnet_name}-beap"
  frontend_port_name             = "${data.terraform_remote_state.vnet.outputs.vnet_name}-feport"
  frontend_ip_configuration_name = "${data.terraform_remote_state.vnet.outputs.vnet_name}-feip"
  http_setting_name              = "${data.terraform_remote_state.vnet.outputs.vnet_name}-be-htst"
  listener_name                  = "${data.terraform_remote_state.vnet.outputs.vnet_name}-httplstn"
  request_routing_rule_name      = "${data.terraform_remote_state.vnet.outputs.vnet_name}-rqrt"
  redirect_configuration_name    = "${data.terraform_remote_state.vnet.outputs.vnet_name}-rdrcfg"
}

resource "azurerm_public_ip" "main-app-gateway-public-ip" {
  name                = "application-gateway-public-ip"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "main-app-gateway" {
  name                = "application-gateway-${var.enviroment}"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = data.terraform_remote_state.vnet.outputs.public_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.main-app-gateway-public-ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  tags = var.tags
}


