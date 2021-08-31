resource "azurerm_resource_group" "example" {
  name     = "test"
  location = "West US"
}

resource "azurerm_virtual_network" "example" {
  name                = "test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}



resource "azurerm_local_network_gateway" "hub" {
  name                = "hublocalgw"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  gateway_address     = azurerm_public_ip.cisco.ip_address
  address_space       = azurerm_virtual_network.core.address_space
}

resource "azurerm_public_ip" "vpngw" {
  name                = "hubvpngw-pubip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "hub" {
  name                = "hubvpngw"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpngw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_virtual_network.core.subnet.*.id[0]
  }

  #   vpn_client_configuration {
  #     address_space = ["172.20.0.0/16"]
  #   }
}

resource "azurerm_virtual_network_gateway_connection" "hub" {
  name                = "hubvpngwconn"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub.id

  shared_key = "Cisco_123"
}