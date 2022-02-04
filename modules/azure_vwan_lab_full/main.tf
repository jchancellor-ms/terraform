resource "random_string" "namestring" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

locals {
  la_workspace_name = "vwan-hub-lab-${random_string.namestring.result}"
  rg_name           = "rg-vwan-hub-lab-root-${random_string.namestring.result}"

  cloud_tags = {
    environment = "demo"
    location    = var.root_rg_location
  }
}

resource "azurerm_resource_group" "root_hub_rg" {
  name     = local.rg_name
  location = var.root_rg_location
  tags     = local.cloud_tags
}

module "root_log_analytics" {
  source = "../azure_log_analytics_simple"

  rg_name     = azurerm_resource_group.root_hub_rg.name
  rg_location = azurerm_resource_group.root_hub_rg.location
  la_name     = local.la_workspace_name
  tags        = local.cloud_tags
}

resource "azurerm_virtual_wan" "lab_vwan" {
  name                = "vwan_lab_vwan-${random_string.namestring.result}"
  resource_group_name = azurerm_resource_group.root_hub_rg.name
  location            = azurerm_resource_group.root_hub_rg.location
}

#Site 1
module "azure_vwan_lab_site_1" {

  site_root                = random_string.namestring.result
  rg_location              = azurerm_resource_group.root_hub_rg.location
  tags                     = local.cloud_tags
  vwan_id                  = azurerm_virtual_wan.lab_vwan.id
  vwan_hub_address_prefix  = ["10.100.0.0/23"]
  vwan_site_index          = "1"
  hub_vnet_address_space   = ["10.110.0.0/16"]
  gateway_subnet_prefix    = ["10.110.1.0/24"]
  firewall_subnet_prefix   = ["10.110.2.0/24"]
  bastion_subnet_prefix    = ["10.110.3.0/24"]
  spoke_vnet_address_space = ["10.111.0.0/16"]
  web_subnet_prefix        = ["10.111.1.0/24"]
  data_subnet_prefix       = ["10.110.2.0/24"]
  vm_sku                   = "Standard_B2ms"
  os_version_sku           = "2016-Datacenter"
}


#Site 2
module "azure_vwan_lab_site_1" {

  site_root                = random_string.namestring.result
  rg_location              = azurerm_resource_group.root_hub_rg.location
  tags                     = local.cloud_tags
  vwan_id                  = azurerm_virtual_wan.lab_vwan.id
  vwan_hub_address_prefix  = ["10.200.0.0/23"]
  vwan_site_index          = "2"
  hub_vnet_address_space   = ["10.210.0.0/16"]
  gateway_subnet_prefix    = ["10.210.1.0/24"]
  firewall_subnet_prefix   = ["10.210.2.0/24"]
  bastion_subnet_prefix    = ["10.210.3.0/24"]
  spoke_vnet_address_space = ["10.211.0.0/16"]
  web_subnet_prefix        = ["10.211.1.0/24"]
  data_subnet_prefix       = ["10.210.2.0/24"]
  vm_sku                   = "Standard_B2ms"
  os_version_sku           = "2016-Datacenter"
}

#Firewall rules


