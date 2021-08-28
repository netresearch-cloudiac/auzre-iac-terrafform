# On prem core networks created

resource "azurerm_resource_group" "core" {
  #for_each = local.netsuffixset
  provider = azurerm.onpremsim
  name     = "${var.rg_name}-onprem"
  location = var.pry_location
}

resource "azurerm_network_security_group" "coredmz" {
  # for_each = local.netsuffixset
  provider = azurerm.onpremsim
  name                = "nsg_coredmz"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name

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

   security_rule {
    name                       = "AllowSSH"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}

resource "azurerm_virtual_network" "core" {
  # for_each = local.netsuffixset
  provider = azurerm.onpremsim
  name                = "${var.prefix}_vnet-core"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  address_space       = ["172.20.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "172.20.0.0/24"
  }

  subnet {
    name           = "commonsub"
    address_prefix = "172.20.1.0/24"
  }

  subnet {
    name           = "dmzsub"
    address_prefix = "172.20.2.0/24"
    security_group = azurerm_network_security_group.coredmz.id
  }

    subnet {
    name           = "mgtsub"
    address_prefix = "172.20.3.0/24"
  }

  tags = var.tags
}