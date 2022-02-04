#create the vnet hub

module "azure_vnet_hub_extra_subnets" {
  source = "../azure_vnet_hub_extra_subnets"

  vnet_name              = var.hub_vnet_name
  vnet_address_space     = var.vnet_address_space
  rg_name                = var.rg_name
  rg_location            = var.rg_location
  gateway_subnet_prefix  = var.gateway_subnet_prefix
  firewall_subnet_prefix = var.firewall_subnet_prefix
  bastion_subnet_prefix  = var.bastion_subnet_prefix
  dc_subnet_prefix       = var.dc_subnet_prefix
  tags                   = var.tags
}

#create the bastion
module "azure_bastion_simple" {
  source = "../azure_bastion_simple"

  pip_name          = var.bastion_pip_name
  bastion_name      = var.bastion_name
  rg_name           = module.azure_vnet_hub_extra_subnets.rg_name
  rg_location       = var.rg_location
  bastion_subnet_id = module.azure_vnet_hub_extra_subnets.bastion_subnet_id
}

#create the base firewall
module "azure_firewall_hub_no_rules" {
  source = "../azure_firewall_hub_no_rules"

  rg_name                     = module.azure_vnet_hub_extra_subnets.rg_name
  rg_location                 = var.rg_location
  firewall_sku_tier           = var.firewall_sku_tier
  tags                        = var.tags
  firewall_pip_name           = var.firewall_pip_name
  firewall_name               = var.firewall_name
  hub_vnet_firewall_subnet_id = module.azure_vnet_hub_extra_subnets.firewall_subnet_id
  log_analytics_id            = var.log_analytics_id
}