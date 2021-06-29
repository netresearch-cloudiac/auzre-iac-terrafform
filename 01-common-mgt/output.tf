output "resrouce_group_name" {
    value = azurerm_resource_group.cmmgt.name
}

output "storage_account_name" {
    value = azurerm_storage_account.cmmgt.name
}

output "storage_container_name" {
    value = azurerm_storage_container.cmmgt.name
}

output "storage_versioning_flag" {
    value = azurerm_storage_account.cmmgt.blob_properties[0].versioning_enabled 
}