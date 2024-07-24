terraform {
  required_version = "> 1.7.5"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "1.13.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "azurecli",
      "--environment",
      "AzurePublicCloud",
      "--tenant-id",
      data.azurerm_client_config.current.tenant_id,
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630", # Azure Kubernetes Service AAD Server - Enterprise Application
    ]
  }
}


provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--login",
        "azurecli",
        "--environment",
        "AzurePublicCloud",
        "--tenant-id",
        data.azurerm_client_config.current.tenant_id,
        "--server-id",
        "6dae42f8-4368-4678-94ff-3960e28e3630", # Azure Kubernetes Service AAD Server - Enterprise Application
      ]
    }
  }
}