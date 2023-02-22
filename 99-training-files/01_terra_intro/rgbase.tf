resource "azurerm_resource_group" "rg_base" {
    name = "RG-Base"
    location = "East US"
}

resource "azurerm_virtual_network" "vnet_base" {
    name = "VNET-Base"
    location = azurerm_resource_group.rg_base.location
    resource_group_name = azurerm_resource_group.rg_base.name
    address_space = ["172.18.0.0/16"]
    
    subnet {
            name = "GatewaySubnet"
            address_prefix = "172.18.0.0/24"
        }
    
    subnet {
            name = "web-subnet"
            address_prefix = "172.18.1.0/24"
    }

    subnet {
            name = "app-subnet"
            address_prefix = "172.18.2.0/24"
    }

    subnet {
            name = "infra-subnet"
            address_prefix = "172.18.3.0/24"
    }

    
    tags = {
        environment = "Terraform"
    }
  

}