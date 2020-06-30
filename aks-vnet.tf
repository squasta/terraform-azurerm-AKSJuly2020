
#Creating the AKS Vnet

resource "azurerm_virtual_network" "Terra_aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = azurerm_resource_group.Terra_aks_rg.name
  location            = azurerm_resource_group.Terra_aks_rg.location
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "Terra_aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.Terra_aks_rg.name
  virtual_network_name = azurerm_virtual_network.Terra_aks_vnet.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "Terra_aks_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.Terra_aks_rg.name
  virtual_network_name = azurerm_virtual_network.Terra_aks_vnet.name
  address_prefixes     = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "Terra_aks_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.Terra_aks_rg.name
  virtual_network_name = azurerm_virtual_network.Terra_aks_vnet.name
  address_prefixes     = ["10.253.0.0/16"]
}

resource "azurerm_subnet" "Terra_aks_aci_subnet" {
  name                 = "virtual-node-aci"
  resource_group_name  = azurerm_resource_group.Terra_aks_rg.name
  virtual_network_name = azurerm_virtual_network.Terra_aks_vnet.name
  address_prefixes     = ["10.241.0.0/16"]
  delegation {
    name = "aciDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

###################
# AppGateway Subnet

resource "azurerm_subnet" "Terra_aks_appgw_subnet" {
  name                 = "appgwsubnet"
  resource_group_name  = azurerm_resource_group.Terra_aks_rg.name
  virtual_network_name = azurerm_virtual_network.Terra_aks_vnet.name
  address_prefixes     = ["10.252.0.0/16"]
}




#Role Assignment to give AKS the access to VNET - Required for Advanced Networking
# resource "azurerm_role_assignment" "aks-vnet-role" {
#   scope                = azurerm_virtual_network.aks_vnet.id
#   role_definition_name = "Contributor"
#   principal_id         = data.azuread_service_principal.spn.id
# }

# Grant AKS cluster access to join AKS subnet
# resource "azurerm_role_assignment" "aks_subnet" {
#   scope                = "${azurerm_subnet.aks.id}"
#   role_definition_name = "Network Contributor"
#   principal_id         = "${azuread_service_principal.main.id}"
# }

# Grant AKS cluster access to join ACI subnet
# resource "azurerm_role_assignment" "aci_subnet" {
#   scope                = "${azurerm_subnet.aci.id}"
#   role_definition_name = "Network Contributor"
#   principal_id         = "${azuread_service_principal.main.id}"
# }

