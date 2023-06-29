terraform {
  required_version = "v1.3.5"

  backend "azurerm" {
    resource_group_name  = "showcase-dev-tfstate"
    storage_account_name = "showcasedevaccount"
    container_name       = "showcase-dev-container"
    key                  = "showcase-dev-kubernetes-tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.62.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.10.0"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}
