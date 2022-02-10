locals {
  hub_vnet_name     = "vnet-hub-${var.site_root}-${random_string.namestring.result}"
  hub_rg_name       = "rg-vnet-hub-${var.site_root}-${random_string.namestring.result}"
  bastion_pip_name  = "pip-bastion-${var.site_root}-${random_string.namestring.result}"
  bastion_name      = "bastion-${var.site_root}-${random_string.namestring.result}"
  firewall_pip_name = "pip-firewall-${var.site_root}-${random_string.namestring.result}"
  firewall_name     = "firewall-${var.site_root}-${random_string.namestring.result}"

  spoke_vnet_name  = "vnet-spoke-${var.site_root}-${random_string.namestring.result}"
  spoke_rg_name    = "rg-spoke-${var.site_root}-${random_string.namestring.result}"
  web_subnet_name  = "subnet-spoke-web-${var.site_root}-${random_string.namestring.result}"
  data_subnet_name = "subnet-spoke-data-${var.site_root}-${random_string.namestring.result}"

  keyvault_name = "keyvault-${var.site_root}-${random_string.namestring.result}"

  vm_name = "winvm-${var.site_root}-${random_string.namestring.result}"

  web_route_table_name  = "rt-spoke-web-${var.site_root}-${random_string.namestring.result}"
  data_route_table_name = "rt-spoke-data-${var.site_root}-${random_string.namestring.result}"
}

resource "random_string" "namestring" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

#hub module configuration 
module "azure_hub_with_firewall_and_bastion" {
  source = "../azure_hub_with_firewall_and_bastion"

  hub_vnet_name          = local.hub_vnet_name
  vnet_address_space     = var.hub_vnet_address_space
  rg_name                = local.hub_rg_name
  rg_location            = var.rg_location
  gateway_subnet_prefix  = var.gateway_subnet_prefix
  firewall_subnet_prefix = var.firewall_subnet_prefix
  bastion_subnet_prefix  = var.bastion_subnet_prefix
  dc_subnet_prefix       = var.dc_subnet_prefix
  tags                   = var.tags
  bastion_pip_name       = local.bastion_pip_name
  bastion_name           = local.bastion_name
  firewall_sku_tier      = "Standard"
  firewall_pip_name      = local.firewall_pip_name
  firewall_name          = local.firewall_name
  log_analytics_id       = var.log_analytics_id
}

#spoke module configuration
module "azure_spoke_with_custom_dns" {
  source = "../azure_spoke_with_custom_dns"

  vnet_name          = local.spoke_vnet_name
  address_space      = var.spoke_vnet_address_space
  rg_name            = local.spoke_rg_name
  rg_location        = var.rg_location
  web_subnet_name    = local.web_subnet_name
  web_subnet_prefix  = var.web_subnet_prefix
  data_subnet_name   = local.data_subnet_name
  data_subnet_prefix = var.data_subnet_prefix
  tags               = var.tags
  dns_servers        = [module.azure_hub_with_firewall_and_bastion.firewall_private_ip_address]

  depends_on = [
    module.azure_hub_with_firewall_and_bastion
  ]
}


#Peering Configuration
module "azure_vnet_peering_spoke_no_gateway" {

  source = "../azure_vnet_peering_spoke_no_gateway"

  hub_vnet_name   = local.hub_vnet_name
  hub_vnet_id     = module.azure_hub_with_firewall_and_bastion.vnet_id
  spoke_vnet_name = local.spoke_vnet_name
  spoke_rg_name   = local.spoke_rg_name

  depends_on = [
    module.azure_spoke_with_custom_dns
  ]
}

module "azure_vnet_peering_hub_default" {
  source          = "../azure_vnet_peering_hub_defaults"
  spoke_vnet_name = local.spoke_vnet_name
  spoke_vnet_id   = module.azure_spoke_with_custom_dns.spoke_vnet_id
  hub_vnet_name   = local.hub_vnet_name
  hub_rg_name     = local.hub_rg_name

  depends_on = [
    module.azure_hub_with_firewall_and_bastion
  ]
}

#key vault
data "azurerm_client_config" "current" {
}

module "azure_keyvault_with_access_policy" {
  source = "../azure_keyvault_with_access_policy"

  #values to create the keyvault
  rg_name             = local.spoke_rg_name
  rg_location         = var.rg_location
  keyvault_name       = local.keyvault_name
  azure_ad_tenant_id  = data.azurerm_client_config.current.tenant_id
  lab_admin_object_id = data.azurerm_client_config.current.object_id
  tags                = var.tags

  depends_on = [
    module.azure_spoke_with_custom_dns
  ]
}

#test server
module "azure_guest_server_multiversion_plain" {
  source = "../azure_guest_server_multiversion_plain"

  rg_name        = local.spoke_rg_name
  rg_location    = var.rg_location
  vm_name        = local.vm_name
  subnet_id      = module.azure_spoke_with_custom_dns.web_subnet_id
  vm_sku         = var.vm_sku
  key_vault_id   = module.azure_keyvault_with_access_policy.keyvault_id
  os_version_sku = var.os_version_sku
  tags           = var.tags

  depends_on = [
    module.azure_keyvault_with_access_policy
  ]
}

#spoke routes
resource "azurerm_route_table" "spoke-web" {
  name                          = local.web_route_table_name
  location                      = var.rg_location
  resource_group_name           = local.spoke_rg_name
  disable_bgp_route_propagation = false
  tags                          = var.tags

  depends_on = [
    module.azure_spoke_with_custom_dns
  ]
}


resource "azurerm_route_table" "spoke-data" {
  name                          = local.data_route_table_name
  location                      = var.rg_location
  resource_group_name           = local.spoke_rg_name
  disable_bgp_route_propagation = false
  tags                          = var.tags

  depends_on = [
    module.azure_spoke_with_custom_dns
  ]
}

resource "azurerm_route" "spoke-web" {
  name                   = "${local.web_route_table_name}-webroute"
  resource_group_name    = local.spoke_rg_name
  route_table_name       = azurerm_route_table.spoke-web.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.azure_hub_with_firewall_and_bastion.firewall_private_ip_address
}

resource "azurerm_route" "spoke-data" {
  name                   = "${local.data_route_table_name}-dataroute"
  resource_group_name    = local.spoke_rg_name
  route_table_name       = azurerm_route_table.spoke-data.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.azure_hub_with_firewall_and_bastion.firewall_private_ip_address
}

resource "azurerm_subnet_route_table_association" "spoke-web" {
  subnet_id      = module.azure_spoke_with_custom_dns.web_subnet_id
  route_table_id = azurerm_route_table.spoke-web.id

  depends_on = [
    module.azure_spoke_with_custom_dns
  ]
}

resource "azurerm_subnet_route_table_association" "spoke-data" {
  subnet_id      = module.azure_spoke_with_custom_dns.data_subnet_id
  route_table_id = azurerm_route_table.spoke-data.id

  depends_on = [
    module.azure_spoke_with_custom_dns
  ]
}