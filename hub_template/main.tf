locals {
  peer_details = csvdecode(file(var.peer_csv_filename))
}


module "azure_hub_with_firewall_and_bastion" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_hub_with_firewall_and_bastion?ref=v0.0.9"

  hub_vnet_name          = var.hub_vnet_name
  vnet_address_space     = var.vnet_address_space
  rg_name                = var.rg_name
  rg_location            = var.rg_location
  gateway_subnet_prefix  = var.gateway_subnet_prefix
  firewall_subnet_prefix = var.firewall_subnet_prefix
  bastion_subnet_prefix  = var.bastion_subnet_prefix
  tags                   = var.tags
  bastion_pip_name       = var.bastion_pip_name
  bastion_name           = var.bastion_name
  firewall_sku_tier      = var.firewall_sku_tier
  firewall_pip_name      = var.firewall_pip_name
  firewall_name          = var.firewall_name
  log_analytics_id       = var.log_analytics_id
}

module "azure_vnet_peering_hub_defaults" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_vnet_peering_hub_defaults?ref=v0.0.9"

  for_each = { for peer in local.peer_details : peer.spoke_vnet_name => peer }

  hub_rg_name     = var.rg_name
  hub_vnet_name   = var.hub_vnet_name
  spoke_vnet_name = each.value.spoke_vnet_name
  spoke_vnet_id   = each.value.spoke_vnet_id
}

