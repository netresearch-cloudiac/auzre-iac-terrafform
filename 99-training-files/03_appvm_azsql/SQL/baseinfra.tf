data azurerm_virtual_network "vnet_base" {
    name = "VNET-Base"
    resource_group_name = var.infra_rg_name
}

data azurerm_subnet "web-subnet" {
    name = "web-subnet"
    virtual_network_name = "VNET-Base"
    resource_group_name = var.infra_rg_name
}

data "azurerm_subnet" "app-subnet" {
    name = "app-subnet"
    virtual_network_name = "VNET-Base"
    resource_group_name = var.infra_rg_name
}

data "azurerm_subnet" "db-subnet" {
    name = "db-subnet"
    virtual_network_name = "VNET-Base"
    resource_group_name = var.infra_rg_name
}

resource "azurerm_resource_group" "rg_vm" {
    name = var.rg_name
    location = var.pry_location
    tags = var.tags
}
