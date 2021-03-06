#Replace the comments below with the environment specific details
#rename this file to providers.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }

  /*
  backend "azurerm" {
    resource_group_name = "<replace with tfstate resource group name>"
    storage_account_name = "<replace with tfstate storage account name>"
    container_name = "<replace with tfstate storage account container name>"
    key = "<replace with a filename for the state file with .tfstate suffix>"
  }
  */


}


provider "azurerm" {
  features {}
}