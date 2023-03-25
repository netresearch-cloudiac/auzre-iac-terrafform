resource "azurerm_network_security_group" "linux-vm" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.rg_base.location
  resource_group_name = azurerm_resource_group.rg_base.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "windows-vm" {
  name                = "acceptanceTestSecurityGroup2"
  location            = azurerm_resource_group.rg_base.location
  resource_group_name = azurerm_resource_group.rg_base.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}