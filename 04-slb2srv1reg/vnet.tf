resource "azurerm_virtual_network" "slb2srv" {
  name                = var.vnet_name
  location            = azurerm_resource_group.slb2srv.location
  resource_group_name = azurerm_resource_group.slb2srv.name
  address_space       = var.vnet_address_space
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = var.vnet_subnet01
  }

  subnet {
    name           = "subnet2"
    address_prefix = var.vnet_subnet02
  }

  tags = var.tags
}