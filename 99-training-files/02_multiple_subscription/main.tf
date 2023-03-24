# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  alias = "hub-payg"
  subscription_id = "edcca641-2e81-4a93-be90-738694820c7f"
  features {}
}

provider "azurerm" {
  alias = "spoke-free"
  subscription_id = "a6e4c7db-a5a1-44a0-9ce9-20b51f4ea671"
  features {}
}