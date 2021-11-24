
resource "azurerm_resource_group" "tfstate_rg" {
  name     = var.rg_name
  location = var.rg_location

  tags = var.tags
}

resource "random_string" "random_storage_part" {
  length           = 5
  special          = false
  upper            = false
}

resource "azurerm_storage_account" "tfstate_storage_account" {
  name                     = "tfinfratfstate${random_string.random_storage_part.id}"
  resource_group_name      = azurerm_resource_group.tfstate_rg.name
  location                 = azurerm_resource_group.tfstate_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
  
  blob_properties {
    versioning_enabled = true
    change_feed_enabled = true
  }

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate_blob_container" {
  name                  = var.state_container_name
  storage_account_name  = azurerm_storage_account.tfstate_storage_account.name
  container_access_type = "private"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "tfstate_infra_kv" {
  name                        = "${var.tfstate_keyvault_name}-${random_string.random_storage_part.id}"
  location                    = azurerm_resource_group.tfstate_rg.location
  resource_group_name         = azurerm_resource_group.tfstate_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment = true

  sku_name = "standard"

  tags = var.tags    
}