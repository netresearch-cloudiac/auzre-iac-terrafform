
resource "azurerm_route_table" "websub-routetbl" {
  name                          = "websubnet-route-table"
  location                      = var.pry_location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name           = "Wiregaurdroute1"
    address_prefix = "192.168.6.0/24"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "172.18.2.4"
  }

  tags = var.tags
}

