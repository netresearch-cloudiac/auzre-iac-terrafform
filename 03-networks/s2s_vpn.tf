# VPN Gateway and S2S configuration to onprem Csico CSR1000

resource "azurerm_local_network_gateway" "hub" {
  name                = "hublocalgw"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  gateway_address     = azurerm_public_ip.cisco.ip_address
  address_space       = azurerm_virtual_network.core.address_space
  bgp_settings {
    asn = 65010
    bgp_peering_address = azurerm_network_interface.cisco_nic.private_ip_address
  }
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

  bgp_settings {
    asn = 65515
  }

  #   vpn_client_configuration {
  #     address_space = ["172.20.0.0/16"]
  #   }

  tags = var.tags
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