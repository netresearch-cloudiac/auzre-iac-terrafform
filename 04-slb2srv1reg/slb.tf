# # define load balancer

# resource "azurerm_public_ip" "frontend" {
#  name                         = "publicIPForLB"
#  location                     = azurerm_resource_group.slb2srv.location
#  resource_group_name          = azurerm_resource_group.slb2srv.name
#  allocation_method            = "Static"
# }

# resource "azurerm_lb" "slb2srv" {
#  name                = "loadBalancer"
#  location            = azurerm_resource_group.slb2srv.location
#  resource_group_name = azurerm_resource_group.slb2srv.name

#  frontend_ip_configuration {
#    name                 = "publicIPAddress"
#    public_ip_address_id = azurerm_public_ip.frontend.id
#  }
# }

# resource "azurerm_lb_backend_address_pool" "slb2srv" { 
#  resource_group_name = azurerm_resource_group.slb2srv.name
#  loadbalancer_id     = azurerm_lb.slb2srv.id
#  name                = "BackEndAddressPool"
# }

resource "azurerm_public_ip" "slbpubip" {
  name                = "${var.prefix}-lbpubip"
  resource_group_name = azurerm_resource_group.slb2srv.name
  location            = azurerm_resource_group.slb2srv.location
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-webapp"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "slb2srv" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.slb2srv.location
  resource_group_name = azurerm_resource_group.slb2srv.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.prefix}-lbPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.slbpubip.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "slb2srv" {
  loadbalancer_id     = azurerm_lb.slb2srv.id
  name                = "${var.prefix}-lbBackEndAddressPool"
}

resource "azurerm_lb_probe" "slb2srv" {
  resource_group_name = azurerm_resource_group.slb2srv.name
  loadbalancer_id     = azurerm_lb.slb2srv.id
  name                = "HTTP-probe"
  protocol            = "Tcp"
  port                = 80
}

resource "azurerm_lb_nat_rule" "slb2srv" {
  resource_group_name            = azurerm_resource_group.slb2srv.name
  loadbalancer_id                = azurerm_lb.slb2srv.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "${var.prefix}-lbPublicIPAddress" # see if this can be referenced as object
}

resource "azurerm_lb_rule" "slb2srv" {
  resource_group_name            = azurerm_resource_group.slb2srv.name
  loadbalancer_id                = azurerm_lb.slb2srv.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_id        = azurerm_lb_backend_address_pool.slb2srv.id
  probe_id                       = azurerm_lb_probe.slb2srv.id
  frontend_ip_configuration_name = "${var.prefix}-lbPublicIPAddress"
}

resource "azurerm_network_interface_backend_address_pool_association" "slb2srv" {
  count                   = var.vm_count
  network_interface_id    = element(azurerm_network_interface.slb2srv.*.id, count.index)
  ip_configuration_name   = "pvtip${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.slb2srv.id
}

# NAT to RDP port to first VM
resource "azurerm_network_interface_nat_rule_association" "slb2srv" {
  network_interface_id  = azurerm_network_interface.slb2srv[0].id
  ip_configuration_name = "pvtip0"
  nat_rule_id           = azurerm_lb_nat_rule.slb2srv.id
}

# resource "azurerm_lb_backend_address_pool_address" "example" {
#   name                    = "example"
#   backend_address_pool_id = data.azurerm_lb_backend_address_pool.example.id
#   virtual_network_id      = data.azurerm_virtual_network.example.id
#   ip_address              = "10.0.0.1"
# }