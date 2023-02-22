output "linux-vm-name" {
    value = azurerm_linux_virtual_machine.linux-vm.name
}

output "linux-pvt-ip" {
  value = azurerm_linux_virtual_machine.linux-vm.private_ip_address
}

output "linux-pup-ip" {
  value = azurerm_linux_virtual_machine.linux-vm.public_ip_address
}