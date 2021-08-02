output "resrouce_group_name" {
  value = azurerm_resource_group.slb2srv.name
}

output "vnet_address" {
  value = azurerm_virtual_network.slb2srv.address_space
}