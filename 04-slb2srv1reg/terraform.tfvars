rg_name      = "RG-slb2srv"
pry_location = "East US"
tags = {
  Author      = "Dheep Balaraman"
  Environment = "Test"
  Project     = "Tier4app"
  Can_delete  = "True"
}
vnet_name          = "tier4_vnet01"
vnet_address_space = ["192.168.0.0/16"]
vnet_subnet01      = "192.168.11.0/24"
vnet_subnet01_name = "websubnet"
vnet_subnet02      = "192.168.12.0/24"
vnet_subnet02_name = "appsubnet"

# VM details
prefix      = "tier4"
vm_username = "azadmin"
vm_password = "Password_1234!"
vm_count    = 2