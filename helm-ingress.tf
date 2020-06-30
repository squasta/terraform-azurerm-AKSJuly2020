# data "helm_repository" "Terra-AzureMarketPlace" {
#   name = "Bitnami-AzureMarketPlace"
#   url  = "https://marketplace.azurecr.io/helm/v1/repo"
# }



# cf https://bitnami.com/stack/nginx-ingress-controller/helm
#    https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller 
#    https://github.com/bitnami/charts/blob/master/bitnami/nginx-ingress-controller/values.yaml
resource "helm_release" "Terra-ingress" {
  name       = "my-nginx-ingress"
  repository = data.helm_repository.Terra-AzureMarketPlace.metadata[0].name
  chart      = "nginx-ingress-controller"
  timeout    = 600

  set {
    name  = "kind"
    value = "Deployment"
  }

  set {
    name  = "replicaCount"
    value = 3
  }

  set {
    name  = "minAvailable"
    value = 1
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


