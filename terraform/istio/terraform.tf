terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.18.0"
    }    
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg_assignment"
    storage_account_name = "storageassignment032023"
    container_name       = "containerassignment032023"
    key                  = "assignment-istio-install.tfstate"
  }

}

provider "azurerm" {
  features {}
  # skip_provider_registration = true
}

data "azurerm_kubernetes_cluster" "credentials" {
  name = "aksassignment"
  resource_group_name = data.azurerm_resource_group.this.name
}

provider "helm" {
  kubernetes {
    host     = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host

    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  }
}


provider "kubernetes" {
    host     = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host

    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
}

