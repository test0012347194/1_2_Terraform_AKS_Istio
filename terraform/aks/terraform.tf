terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.18.0"
    }    
  }

  backend "azurerm" {
    resource_group_name  = "rg_assignment"
    storage_account_name = "storageassignment032023"
    container_name       = "containerassignment032023"
    key                  = "assignment-aks.tfstate"
  }

}
provider "azurerm" {
  features {}
  # skip_provider_registration = true
}