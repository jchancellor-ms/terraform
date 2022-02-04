

locals {
  vwan_rg_name = "rg-vwan-hub-${var.site_root}-${var.vwan_site_index}"
}

resource "azurerm_resource_group" "vwan_hub_rg" {
  name     = local.vwan_rg_name
  location = var.vwan_rg_location
  tags     = var.tags
}

#vwan hub creation

resource "azurerm_virtual_hub" "vwan_hub_this" {
  name                = "vwan-hub-site-${var.vwan_site_index}"
  resource_group_name = azurerm_resource_group.vwan_hub_rg.name
  location            = azurerm_resource_group.vwan_hub_rg.location
  virtual_wan_id      = var.vwan_id
  address_prefix      = var.vwan_hub_address_prefix
  sku                 = "Standard"
  tags                = var.tags
}

