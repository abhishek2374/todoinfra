terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
   backend "azurerm" {
     resource_group_name  = "abhi_stg_be_state_rg"
     storage_account_name = "todoinfrabestate"
     container_name       = "terraformstate"
     key                  = "dev.terraform.tfstate"
   }
 }

provider "azurerm" {
  features {}
  subscription_id = "e5c8e042-8d4d-4e69-8511-a29fb378ec23"
}
