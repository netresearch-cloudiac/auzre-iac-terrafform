
resource "azurerm_public_ip" "linux-vm" {
    name = "linux-vm-pubip"
    resource_group_name = azurerm_resource_group.rg_base.name
    location = azurerm_resource_group.rg_base.location
    domain_name_label = "dblinuxvm01"
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
        subnet_id = azurerm_subnet.app-subnet.id
        // subnet_id = azurerm_virtual_network.vnet_base.subnet.*.id[1]
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.linux-vm.id
    }
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
    name = "linux-vm"
    resource_group_name = azurerm_resource_group.rg_base.name
    location = azurerm_resource_group.rg_base.location
    size = "Standard_DS1_v2"
    admin_username = "azureuser"
    disable_password_authentication = false
    admin_password = "Pa$$w0rd1234!"
    network_interface_ids = [azurerm_network_interface.linux-vm.id]
    priority = "Spot"
    eviction_policy = "Deallocate"
        identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "linux-vm-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 30
    }

    # source_image_reference {
    #     publisher = "Canonical"
    #     offer = "UbuntuServer"
    #     sku = "18.04-LTS"
    #     version = "latest"
    # }
    
    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-focal"
        //sku = "18.04-LTS"
        sku = "20_04-lts"   
        version = "latest"
    }


    # cloud init configuration
    custom_data = data.cloudinit_config.linux-vm.rendered

    tags = var.tags

}

resource "azurerm_virtual_machine_extension" "linux-vm-aad" {
    name = "aad-extension"
    # location = azurerm_resource_group.rg_base.location
    # resource_group_name = azurerm_resource_group.rg_base.name
    virtual_machine_id = azurerm_linux_virtual_machine.linux-vm.id
    # publisher = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
    # type = "AADLoginForLinux"
    publisher = "Microsoft.Azure.ActiveDirectory"
    type = "AADSSHLoginForLinux"
    type_handler_version = "1.0"
    auto_upgrade_minor_version = true
}

resource "azurerm_network_interface_security_group_association" "linux-vm" {
    network_interface_id = azurerm_network_interface.linux-vm.id
    network_security_group_id = azurerm_network_security_group.linux-vm.id
}

output "linux-vm-name" {
    value = azurerm_linux_virtual_machine.linux-vm.name
}

output "linux-pvt-ip" {
  value = azurerm_linux_virtual_machine.linux-vm.private_ip_address
}

output "linux-pup-ip" {
  value = azurerm_linux_virtual_machine.linux-vm.public_ip_address
}

output "linux-dns-name" {
    value = azurerm_public_ip.linux-vm.fqdn
}
