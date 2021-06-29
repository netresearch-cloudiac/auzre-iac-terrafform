terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cmmgt" {
  name     = var.rg_name
  location = var.pry_location
  tags = var.tags
}

resource "azurerm_storage_account" "cmmgt" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.cmmgt.name
  location                 = azurerm_resource_group.cmmgt.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  blob_properties {
      versioning_enabled = true
  }
  
  tags = var.tags
}

resource "azurerm_storage_container" "cmmgt" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.cmmgt.name
  container_access_type = "private"
}
