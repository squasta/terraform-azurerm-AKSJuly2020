# Azure Kubernetes Service Cluster deployment with Terraform


=== Still work in progress === version up to date July 2020

= Tested with success with Terraform v0.12.24 + Azurerm provider version v2.16.0 + Kubernetes provider v1.11.0 + Helm Provider 1.0.0 + random Provider 2.2.1

--------------------------------------------------------------------------------------------------------

This is a set of Terraform files used to deploy an Azure Kubernetes Cluster with all new 2020 features :

- Nodes will be dispatched in different Availability Zones (AZ)
- Node pools will support Autoscaling
- pool1 is a linux node pool (it is mandatory because of kube system pods)
- pool2 is a windows server 2019 node pool with a taint
- System Managed Identities are used instead of Service Principal
- Choice of SKU (Free or Paid) for Azure Kubernetes Service (Control Plane)

These Terraform files can be used to deploy the following Azure components :

- An Azure Resource Group
- An Azure Kubernetes Services Cluster with 1 node pool running Linux 
- An additionnal node pool (pool2) with Windows Server 2019 nodes
- A linux virtual node (Azure Container Instance) through a Virtual Kubelet
- An Azure Load Balancer Standard SKU
- A Virtual Network with it Subnets (subnet for AKS Pods, subnets for AzureBastion and AzureFirewall/NVA if needed, Pods running in ACI through Virtual Kubelet)
- An Azure Log Analytics Workspace + Containers solutions

On Kubernetes, these Terraform files will :

- Create a ClusterRole Binding to give cluster-admin permissions to Kubernetes-Dashboard (usefull if Kubernetes version <1.16)
- Deploy Grafana using Bitnami Helm Chart (from Bitnami repo or from AzureMarketplace repo that is my default choice)

__Prerequisites :__

- An Azure Subscription with enough privileges (create RG, AKS...)
- Azure CLI 2.8.0 or >: <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest>
   And you need to activate features that are still in preview and add extension aks-preview to azure CLI (az extension add --name aks-preview)
- Terraform CLI 0.12.24 or > : <https://www.terraform.io/downloads.html>
- Helm CLI 3.1.1 or > : <https://helm.sh/docs/intro/install/> if you need to test Helm charts

__To deploy this infrastructure :__

1. Log to your Azure subscription (az login)
2. Create an Azure Key Vault and create all secrets defined in datasource.tf
3. Define the value of each variable in .tf and/or .tfvars files
4. Initialize your terraform deployment : `terraform init`
5. Plan your terraform deployment : `terraform plan --var-file=myconf.tfvars`
6. Apply your terraform deployment : `terraform apply --var-file=myconf.tfvars`

__For more information about Terraform & Azure, Kubernetes few additional online resources :__

- My blog : <https://stanislas.io>
- Julien's blog : <https://blog.jcorioland.io/>
- Terraform documentation : <https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html>
- Azure Terraform Provider : <https://github.com/terraform-providers/terraform-provider-azurerm>
- Azure Terraform Provider AKS Cluster : <https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/azurerm/resource_arm_kubernetes_cluster.go>
- Guide for scheduling Windows containers in Kubernetes
 <https://kubernetes.io/docs/setup/production-environment/windows/user-guide-windows-containers/>

After deployment is succeeded, you can check your cluster using portal or better with azure cli and the following command: 
`az aks show --resource-group NAMEOFYOURRESOURCEGROUP --name NAMEOFYOURAKSCLUSTER -o jsonc`

Get your kubeconfig using :

`az aks get-credentials --resource-group NAMEOFYOURRESOURCEGROUP --name NAMEOFYOURAKSCLUSTER --admin`

Connect to Kubernetes Dashboard :

`az aks browse --resource-group NAMEOFYOURRESOURCEGROUP --name NAMEOFYOURAKSCLUSTER`

Then open a browser and go to <http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/#!/overview?namespace=default>

![Magic](https://github.com/squasta/AzureKubernetesService-Terraform/raw/master/Magic.gif)
