
# # resource "azurerm_public_ip" "linux-vm2" {
# #     name = "linux-vm2-pubip"
# #     resource_group_name = azurerm_resource_group.rg_base.name
# #     location = azurerm_resource_group.rg_base.location
# #     allocation_method = "Static"
# #     sku = "Standard"
# #       lifecycle {
# #     create_before_destroy = true
# #   }
# # }

# resource "azurerm_network_interface" "linux-vm2" {
#     name = "linux-vm2-nic"
#     resource_group_name = azurerm_resource_group.rg_base.name
#     location = azurerm_resource_group.rg_base.location
    
#     ip_configuration {
#         name = "linux-vm2-ip"
#         // subnet_id = azurerm_subnet.web-subnet.id
#         subnet_id = azurerm_virtual_network.vnet_base.subnet.*.id[1]
#         private_ip_address_allocation = "Dynamic"
#         # public_ip_address_id = azurerm_public_ip.linux-vm2.id
#     }
# }

# resource "azurerm_linux_virtual_machine" "linux-vm2" {
#     name = "linux-vm2"
#     resource_group_name = azurerm_resource_group.rg_base.name
#     location = azurerm_resource_group.rg_base.location
#     size = "Standard_DS1_v2"
#     admin_username = "azureuser"
#     disable_password_authentication = false
#     admin_password = "Pa$$w0rd1234!"
#     network_interface_ids = [azurerm_network_interface.linux-vm2.id]
#     priority = "Spot"
#     eviction_policy = "Deallocate"

#     os_disk {
#         name = "linux-vm2-osdisk"
#         caching = "ReadWrite"
#         storage_account_type = "Standard_LRS"
#         disk_size_gb = 60
#     }

#     source_image_reference {
#         publisher = "Canonical"
#         offer = "UbuntuServer"
#         sku = "18.04-LTS"
#         version = "latest"
#     }


#     # cloud init configuration
#     custom_data = data.cloudinit_config.linux-vm.rendered

# }

# resource "azurerm_network_interface_security_group_association" "linux-vm2" {
#     network_interface_id = azurerm_network_interface.linux-vm2.id
#     network_security_group_id = azurerm_network_security_group.linux-vm.id
# }

# output "linux-vm2-name" {
#     value = azurerm_linux_virtual_machine.linux-vm2.name
# }

# output "linux-vm2-pvt-ip" {
#   value = azurerm_linux_virtual_machine.linux-vm2.private_ip_address
# }