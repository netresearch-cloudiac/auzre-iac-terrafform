resource "azurerm_resource_group" "rg_base" {
    name = var.rg_name
    location = var.pry_location
    tags = var.tags
}

resource "azurerm_virtual_network" "vnet_base" {
    name = "VNET-Base"
    location = azurerm_resource_group.rg_base.location
    resource_group_name = azurerm_resource_group.rg_base.name
    address_space = ["172.18.0.0/16"]
    
    tags = azurerm_resource_group.rg_base.tags
}

resource "azurerm_subnet" "GatewaySubnet" {
    name = "GatewaySubnet"
    resource_group_name = azurerm_resource_group.rg_base.name
    virtual_network_name = azurerm_virtual_network.vnet_base.name
    address_prefixes = ["172.18.0.0/24"]
  }

resource "azurerm_subnet" "web-subnet" {
    name = "web-subnet"
    resource_group_name = azurerm_resource_group.rg_base.name
    virtual_network_name = azurerm_virtual_network.vnet_base.name
    address_prefixes = ["172.18.1.0/24"]
    }

resource "azurerm_subnet" "app-subnet" {
    name = "app-subnet"
    resource_group_name = azurerm_resource_group.rg_base.name
    virtual_network_name = azurerm_virtual_network.vnet_base.name
    address_prefixes = ["172.18.2.0/24"]
    }

resource "azurerm_subnet" "db-subnet" {
    name = "db-subnet"
    resource_group_name = azurerm_resource_group.rg_base.name
    virtual_network_name = azurerm_virtual_network.vnet_base.name
    address_prefixes = ["172.18.3.0/24"]
    }

resource "azurerm_subnet" "infra-subnet" {
    name = "infra-subnet"
    resource_group_name = azurerm_resource_group.rg_base.name
    virtual_network_name = azurerm_virtual_network.vnet_base.name
    address_prefixes = ["172.18.4.0/24"]
    }
