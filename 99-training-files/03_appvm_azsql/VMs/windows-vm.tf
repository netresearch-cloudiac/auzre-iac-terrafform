
resource "azurerm_public_ip" "windows-vm" {
    name = "windows-vm-pubip"
    resource_group_name = var.rg_name
    location = var.pry_location
    domain_name_label = "dbwin825vm01"
    allocation_method = "Static"
    sku = "Standard"
      lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "azurerm_network_interface" "windows-vm" {
    name = "windows-vm-nic"
    resource_group_name = var.rg_name
    location = var.pry_location
    
    ip_configuration {
        name = "windows-vm-ip"
        //subnet_id = azurerm_subnet.web-subnet.id
        subnet_id = data.azurerm_subnet.web-subnet.id
        // subnet_id = azurerm_virtual_network.vnet_base.subnet.*.id[1]
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.windows-vm.id
    }
}

resource "azurerm_windows_virtual_machine" "windows-vm" {
    name = "windows-vm"
    resource_group_name = var.rg_name
    location = var.pry_location
    size = "Standard_DS1_v2"
    admin_username = "azureuser"
    admin_password = "Pa$$w0rd1234!"
    network_interface_ids = [azurerm_network_interface.windows-vm.id]
    priority = "Spot"
    eviction_policy = "Deallocate"
    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "windows-vm-osdisk"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }

    # cloud init configuration
    # custom_data = data.cloudinit_config.windows-vm.rendered

    tags = var.tags

}

resource "azurerm_virtual_machine_extension" "windows-vm-iis" {
  name                 = "iis-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.windows-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "windows-vm-aad" {
    name = "aad-extension"
    virtual_machine_id = azurerm_windows_virtual_machine.windows-vm.id
    publisher = "Microsoft.Azure.ActiveDirectory"
    type = "AADLoginForWindows"
    type_handler_version = "1.0"
    auto_upgrade_minor_version = true
    //type_handler_version = "1.1.0.1"
}


resource "azurerm_network_interface_security_group_association" "windows-vm" {
    network_interface_id = azurerm_network_interface.windows-vm.id
    network_security_group_id = azurerm_network_security_group.windows-vm.id
}

output "windows-vm-name" {
    value = azurerm_windows_virtual_machine.windows-vm.name
}

output "windows-pvt-ip" {
  value = azurerm_windows_virtual_machine.windows-vm.private_ip_address
}

output "windows-pup-ip" {
  value = azurerm_windows_virtual_machine.windows-vm.public_ip_address
}

output "windows-dns-name" {
    value = azurerm_public_ip.windows-vm.fqdn
}