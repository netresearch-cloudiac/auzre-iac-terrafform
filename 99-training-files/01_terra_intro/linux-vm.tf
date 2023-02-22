
resource "azurerm_public_ip" "linux-vm" {
    name = "linux-vm-pubip"
    resource_group_name = azurerm_resource_group.rg_base.name
    location = azurerm_resource_group.rg_base.location
    allocation_method = "Static"
    sku = "Standard"
      lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_interface" "linux-vm" {
    name = "linux-vm-nic"
    resource_group_name = azurerm_resource_group.rg_base.name
    location = azurerm_resource_group.rg_base.location
    
    ip_configuration {
        name = "linux-vm-ip"
        // subnet_id = azurerm_subnet.web-subnet.id
        subnet_id = azurerm_virtual_network.vnet_base.subnet.*.id[1]
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.linux-vm.id
    }
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
    name = "linux-vm"
    resource_group_name = azurerm_resource_group.rg_base.name
    location = azurerm_resource_group.rg_base.location
    size = "Standard_DS2_v2"
    admin_username = "azureuser"
    disable_password_authentication = false
    admin_password = "Pa$$w0rd1234!"
    network_interface_ids = [azurerm_network_interface.linux-vm.id]
    priority = "Spot"
    eviction_policy = "Deallocate"

    os_disk {
        name = "linux-vm-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 30
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }

}

resource "azurerm_network_interface_security_group_association" "linux-vm" {
    network_interface_id = azurerm_network_interface.linux-vm.id
    network_security_group_id = azurerm_network_security_group.linux-vm.id
}
