terraform {
  required_version = "v1.3.5"
  backend "azurerm" {
    resource_group_name  = "showcase-dev-tfstate"
    storage_account_name = "showcasedevaccount"
    container_name       = "showcase-dev-container"
    key                  = "showcase-dev-tfstate"
  }
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.62.1"
    }
  }
}
