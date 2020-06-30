# Configure the Azure Provider
# more info : https://github.com/terraform-providers/terraform-provider-azurerm
# Check Changelog : https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/CHANGELOG.md 
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.00"
  features {}
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.Terra_aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.Terra_aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.Terra_aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.Terra_aks.kube_config.0.cluster_ca_certificate)
  version                = "~> 1.11.0"
}

# Helm provider
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.Terra_aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.Terra_aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.Terra_aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.Terra_aks.kube_config.0.cluster_ca_certificate)
  }
  version = "~> 1.0.0"
}
