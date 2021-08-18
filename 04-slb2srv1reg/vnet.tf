resource "azurerm_virtual_network" "slb2srv" {
  name                = var.vnet_name
  location            = azurerm_resource_group.slb2srv.location
  resource_group_name = azurerm_resource_group.slb2srv.name
  address_space       = var.vnet_address_space
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = var.vnet_subnet01_name
    address_prefix = var.vnet_subnet01
    security_group = azurerm_network_security_group.nwnsg-web.id
  }

  subnet {
    name           = var.vnet_subnet02_name
    address_prefix = var.vnet_subnet02
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "nwnsg-web" {
  name                = "nwnsg-${var.vnet_subnet01_name}"
  location            = azurerm_resource_group.slb2srv.location
  resource_group_name = azurerm_resource_group.slb2srv.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowRDP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}
