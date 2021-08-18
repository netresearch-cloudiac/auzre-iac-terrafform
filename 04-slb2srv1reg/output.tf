output "resrouce_group_name" {
  value = azurerm_resource_group.slb2srv.name
}

output "vnet_address" {
  value = azurerm_virtual_network.slb2srv.address_space
}

output "vm_names" {
  value = azurerm_virtual_machine.slb2srv.*.name
  
}
output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = azurerm_network_interface.slb2srv.*.private_ip_address
}

# output "public_ip_id" {
#   description = "id of the public ip address provisoned."
#   value       = azurerm_public_ip.slb2srv.*.id
# }

# output "public_ip_address" {
#   description = "The actual ip address allocated for the resource."
#   value       = data.azurerm_public_ip.slb2srv.*.ip_address
# }