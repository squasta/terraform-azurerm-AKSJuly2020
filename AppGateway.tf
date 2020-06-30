

####################
# Public IP for App Gateway
# cf. https://www.terraform.io/docs/providers/azurerm/r/public_ip.html

resource "azurerm_public_ip" "Terra_appgw_pub_ip" {
  name                = "appgw-pub-ip"
  location            = azurerm_resource_group.Terra_aks_rg.location
  resource_group_name = azurerm_resource_group.Terra_aks_rg.name
  sku                 = "Standard" # Can be Basic or Standard
  allocation_method   = "Static"   # Can be Static or Dynamic. Public IP Standard SKUs require allocation_method to be set to Stati
}



###################
# Application Gateway resource
resource "azurerm_application_gateway" "Terra-app-gw" {
  name                = var.app_gw_name
  resource_group_name = azurerm_resource_group.Terra_aks_rg.name
  location            = azurerm_resource_group.Terra_aks_rg.location

  sku {
    name     = var.app_gw_sku
    tier     = var.app_gw_tier
    capacity = var.app_gw_capacity
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.Terra_aks_appgw_subnet.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.Terra_appgw_pub_ip.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
  }

  depends_on = [azurerm_virtual_network.Terra_aks_vnet, azurerm_public_ip.Terra_appgw_pub_ip]
}


# User Assigned Identities 
resource "azurerm_user_assigned_identity" "Terra-ManagedIdentity" {
  resource_group_name = azurerm_resource_group.Terra_aks_rg.name
  location            = azurerm_resource_group.Terra_aks_rg.location
  name                = "identity1"
}


####################
# code block to create role assignments:

resource "azurerm_role_assignment" "Terra-ra1" {
  scope                = azurerm_subnet.Terra_aks_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_key_vault_secret.spn_object_id.value
  depends_on           = [azurerm_virtual_network.Terra_aks_vnet]
}

resource "azurerm_role_assignment" "Terra-ra2" {
  scope                = azurerm_user_assigned_identity.Terra-ManagedIdentity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = data.azurerm_key_vault_secret.spn_object_id.value
  depends_on           = [azurerm_user_assigned_identity.Terra-ManagedIdentity]
}

resource "azurerm_role_assignment" "Terra-ra3" {
  scope                = azurerm_application_gateway.Terra-app-gw.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.Terra-ManagedIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.Terra-ManagedIdentity, azurerm_application_gateway.Terra-app-gw]
}

resource "azurerm_role_assignment" "Terra-ra4" {
  scope                = azurerm_resource_group.Terra_aks_rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.Terra-ManagedIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.Terra-ManagedIdentity, azurerm_application_gateway.Terra-app-gw]
}

