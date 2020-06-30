
# data "helm_repository" "Terra-Bitnami" {
#   name = "Bitnami"
#   url  = "https://charts.bitnami.com/bitnami"
# }

# https://github.com/bitnami/charts/tree/master/bitnami/grafana
# https://bitnami.com/stack/grafana/helm 
# resource "helm_release" "Terra-grafana" {
#   name       = "my-grafana"
#   repository = data.helm_repository.Terra-Bitnami.metadata[0].name
#   chart      = "bitnami/grafana"
#   depends_on = [azurerm_kubernetes_cluster.Terra_aks]

#   set {
#     name  = "admin.user"
#     value = var.grafana_admin_username
#   }

#   set {
#     name  = "admin.password"
#     value = data.azurerm_key_vault_secret.grafana_admin_password.value
#   }

#   set {
#     name  = "replicaCount"
#     value = 3
#   }
# }

data "helm_repository" "Terra-AzureMarketPlace" {
  name = "Bitnami-AzureMarketPlace"
  url  = "https://marketplace.azurecr.io/helm/v1/repo"
}

resource "helm_release" "Terra-grafana2" {
  name       = "my-grafana-from-azure"
  repository = data.helm_repository.Terra-AzureMarketPlace.metadata[0].name
  chart      = "azure-marketplace/grafana"
  timeout    = 600

  set {
    name  = "admin.user"
    value = var.grafana_admin_username
  }

  set {
    name  = "admin.password"
    value = data.azurerm_key_vault_secret.grafana_admin_password.value
  }

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "persistence.enabled"
    value = true
  }

  set {
    name  = "persistence.storageClass"
    value = "default"
  }

  set {
    name  = "persistence.accessMode"
    value = "ReadWriteOnce"
  }

  set {
    name  = "persistence.size"
    value = "1Gi"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  # set {
  #   name  = "tolerations"
  #   value = "os=linux:NoSchedule"
  # }

}


