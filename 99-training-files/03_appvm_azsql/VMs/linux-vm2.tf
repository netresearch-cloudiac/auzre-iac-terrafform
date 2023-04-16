
resource "azurerm_public_ip" "linux-vm2" {
    name = "linux-vm2-pubip"
    resource_group_name = var.rg_name
    location = var.pry_location
    domain_name_label = "dblinuxvm02"
    allocation_method = "Static"
    sku = "Standard"
      lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_interface" "linux-vm2" {
    name = "linux-vm2-nic"
    resource_group_name = var.rg_name
    location = var.pry_location
    
    ip_configuration {
        name = "linux-vm2-ip"
        //subnet_id = azurerm_subnet.app-subnet.id
        subnet_id = data.azurerm_subnet.app-subnet.id
        // subnet_id = azurerm_virtual_network.vnet_base.subnet.*.id[1]
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.linux-vm2.id
    }
}

resource "azurerm_linux_virtual_machine" "linux-vm2" {
    name = "linux-vm2"
    resource_group_name = var.rg_name
    location = var.pry_location
    size = "Standard_DS1_v2"
    admin_username = "azureuser"
    disable_password_authentication = false
    admin_password = "Pa$$w0rd1234!"
    network_interface_ids = [azurerm_network_interface.linux-vm2.id]
    priority = "Spot"
    eviction_policy = "Deallocate"
        identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "linux-vm2-osdisk"
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

resource "azurerm_virtual_machine_extension" "linux-vm2-aad" {
    name = "aad-extension"
    # location = var.pry_location
    # resource_group_name = var.rg_name
    virtual_machine_id = azurerm_linux_virtual_machine.linux-vm2.id
    # publisher = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
    # type = "AADLoginForLinux"
    publisher = "Microsoft.Azure.ActiveDirectory"
    type = "AADSSHLoginForLinux"
    type_handler_version = "1.0"
    auto_upgrade_minor_version = true
}

resource "azurerm_network_interface_security_group_association" "linux-vm2" {
    network_interface_id = azurerm_network_interface.linux-vm2.id
    network_security_group_id = azurerm_network_security_group.linux-vm.id
}

output "linux-vm2-name" {
    value = azurerm_linux_virtual_machine.linux-vm2.name
}

output "linux-vm2-pvt-ip" {
  value = azurerm_linux_virtual_machine.linux-vm2.private_ip_address
}

output "linux-vm2-pup-ip" {
  value = azurerm_linux_virtual_machine.linux-vm2.public_ip_address
}

output "linux-vm2-dns-name" {
    value = azurerm_public_ip.linux-vm2.fqdn
}
