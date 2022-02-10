locals {
  hub_connection_name = "vwan-hub-${var.site_root}-${var.vwan_site_index}-vnet-hub-connection"
  vnet_route_name     = "vwan-connection-route-${var.site_root}-${var.vwan_site_index}"
}


#VWAN module
module "azure_vwan_lab_vwan_hub" {
  source = "../azure_vwan_lab_vwan_hub"

  site_root               = var.site_root
  vwan_rg_location        = var.rg_location
  tags                    = var.tags
  vwan_id                 = var.vwan_id
  vwan_hub_address_prefix = var.vwan_hub_address_prefix
  vwan_site_index         = var.vwan_site_index
  vwan_rg_name            = var.vwan_rg_name
}

#Classic Firewall Hub 
module "azure_vwan_lab_classic_hub_spoke" {

  source                   = "../azure_vwan_lab_classic_hub_spoke"
  site_root                = var.site_root
  rg_location              = var.rg_location
  hub_vnet_address_space   = var.hub_vnet_address_space
  gateway_subnet_prefix    = var.gateway_subnet_prefix
  firewall_subnet_prefix   = var.firewall_subnet_prefix
  bastion_subnet_prefix    = var.bastion_subnet_prefix
  dc_subnet_prefix         = var.dc_subnet_prefix
  spoke_vnet_address_space = var.spoke_vnet_address_space
  web_subnet_prefix        = var.web_subnet_prefix
  data_subnet_prefix       = var.data_subnet_prefix
  vm_sku                   = var.vm_sku
  os_version_sku           = var.os_version_sku
  log_analytics_id         = var.log_analytics_id
  tags                     = var.tags
}

#VWAN Vnet associations
resource "azurerm_virtual_hub_connection" "vwan_to_classic_hub" {
  name                      = local.hub_connection_name
  virtual_hub_id            = module.azure_vwan_lab_vwan_hub.vwan_hub_id
  remote_virtual_network_id = module.azure_vwan_lab_classic_hub_spoke.hub_vnet_id

  routing {
    associated_route_table_id = var.vwan_hub_route_table_id

    static_vnet_route {
      name                = local.vnet_route_name
      address_prefixes    = concat(var.web_subnet_prefix, var.data_subnet_prefix)
      next_hop_ip_address = module.azure_vwan_lab_classic_hub_spoke.firewall_private_ip_address
    }
  }
}





