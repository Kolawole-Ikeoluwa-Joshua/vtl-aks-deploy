terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #   version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.serviceprinciple_id
  client_secret   = var.serviceprinciple_key
}