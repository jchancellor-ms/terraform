output "terraform_resource_group_name" {
    value = azurerm_resource_group.tfstate_rg.name
}

output "terraform_resource_group_id" {
    value = azurerm_resource_group.tfstate_rg.id
}

output "terraform_storage_account_name" {
    value = azurerm_storage_account.tfstate_storage_account.name
}

output "terraform_storage_account_id" {
    value = azurerm_storage_account.tfstate_storage_account.id
}

output "terraform_storage_container_name" {
    value = azurerm_storage_container.tfstate_blob_container.name
}

output "terraform_storage_container_id" {
    value = azurerm_storage_container.tfstate_blob_container.id
}

output "terraform_keyvault_name" {
    value = azurerm_key_vault.tfstate_infra_kv.name
}

output "terraform_keyvault_id" {
    value = azurerm_key_vault.tfstate_infra_kv.id
}