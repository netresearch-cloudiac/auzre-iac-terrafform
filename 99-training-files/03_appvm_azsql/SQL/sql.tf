# resource "azurerm_storage_account" "azsqlstraccnt" {
#     name = "azsqlstraccnt"
#     resource_group_name = var.rg_name
#     location = var.pry_location
#     account_tier = "Standard"
#     account_replication_type = "LRS"
#     account_kind = "StorageV2"
#     access_tier = "Hot"
#     enable_https_traffic_only = true
#     is_hns_enabled = true
#     min_tls_version = "TLS1_2"
#     tags = var.tags
# }

resource "azurerm_mssql_server" "azsqlsrv786" {
    name = "azsqlsrv786"
    resource_group_name = var.rg_name
    location = var.pry_location
    version = "12.0"
    administrator_login = "azmsqladmin"
    administrator_login_password = "Pa$$w0rd1234!"
    minimum_tls_version = "1.2"

     azuread_administrator {
        login_username = var.sql_admin_login
        object_id = var.sql_admin_object_id
    }

    connection_policy = "Default"

    identity {
        type = "SystemAssigned"
    }

    public_network_access_enabled = false

    tags = var.tags
}

resource "azurerm_mssql_database" "azsqlinstance01" {
    name = "azsqlinstance01"
    server_id = azurerm_mssql_server.azsqlsrv786.id
    collation = "SQL_Latin1_General_CP1_CI_AS"
    license_type = "LicenseIncluded"
    //max_size_gb = 4
    min_capacity = 0.5
    sku_name = "S0"
    zone_redundant = false
    tags = var.tags
}

resource "azurerm_private_dns_zone" "sqlpvtzone" {
    name = "privatelink.database.windows.net"
    resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sqlvptzonevirlink" {
    name = "sqlvptzonevirlink"
    resource_group_name = var.rg_name
    private_dns_zone_name = azurerm_private_dns_zone.sqlpvtzone.name
    virtual_network_id = data.azurerm_virtual_network.vnet_base.id
    registration_enabled = true
}


resource "azurerm_private_endpoint" "azsqlsrv786_pvtendpt" {
    name = "azsqlsrv786_pvtendpt"
    resource_group_name = var.rg_name
    location = var.pry_location
    subnet_id = data.azurerm_subnet.db-subnet.id
    
    private_service_connection {
        name = "azsqlsrv786_pvtendpt_srvconn"
        is_manual_connection = false
        private_connection_resource_id = azurerm_mssql_server.azsqlsrv786.id
        subresource_names = ["sqlServer"]
    }

    private_dns_zone_group {
        name = "azsqlsrv786_pvtendpt_dnszonegrp"
        private_dns_zone_ids = [azurerm_private_dns_zone.sqlpvtzone.id]
   
    }

    tags = var.tags
}


output "azsql_id" {
    value = azurerm_mssql_database.azsqlinstance01.id
}

output "azsql_name" {
    value = azurerm_mssql_server.azsqlsrv786.fully_qualified_domain_name
}



# Path: 99-training-files\03_appvm_azsql\SQL\sql.tf

