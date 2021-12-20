#set local variable values for deployment
resource "random_string" "namestring" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

locals {



  keyvault_name = "${var.project}-${random_string.namestring.result}"

  cloud_tags = {
    project  = var.project
    location = var.rg_location
  }

}

#create resource group, network hub, and bastion
module "azure_hub_with_bastion" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_hub_with_bastion?ref=v0.0.14"

  hub_vnet_name          = var.hub_vnet_name
  vnet_address_space     = var.hub_vnet_address_space
  rg_name                = var.hub_rg_name
  rg_location            = var.rg_location
  gateway_subnet_prefix  = var.gateway_subnet_prefix
  firewall_subnet_prefix = var.firewall_subnet_prefix
  bastion_subnet_prefix  = var.bastion_subnet_prefix
  tags                   = local.cloud_tags
  bastion_pip_name       = var.bastion_pip_name
  bastion_name           = var.bastion_name
}

#create spoke vnet 
module "azure_spoke_with_custom_dns" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_spoke_with_custom_dns?ref=v0.0.14"

  vnet_name          = var.spoke_vnet_name
  address_space      = var.spoke_vnet_address_space
  rg_name            = var.spoke_rg_name
  rg_location        = var.rg_location
  web_subnet_name    = var.web_subnet_name
  web_subnet_prefix  = var.web_subnet_prefix
  data_subnet_name   = var.data_subnet_name
  data_subnet_prefix = var.data_subnet_prefix
  tags               = local.cloud_tags
  dns_servers        = [var.dc_private_ip, ]
}

#create peering
module "azure_vnet_peering_hub_defaults" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_vnet_peering_hub_defaults?ref=v0.0.14"

  spoke_vnet_name = var.spoke_vnet_name
  spoke_vnet_id   = module.azure_spoke_with_custom_dns.spoke_vnet_id
  hub_vnet_name   = var.hub_vnet_name
  hub_rg_id       = module.azure_hub_with_bastion.rg_id
}

module "azure_vnet_peering_spoke_defaults" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_vnet_peering_spoke_defaults?ref=v0.0.14"

  hub_vnet_name   = var.hub_vnet_name
  hub_vnet_id     = module.azure_hub_with_bastion.vnet_id
  spoke_vnet_name = var.spoke_vnet_name
  spoke_rg_name   = module.azure_spoke_with_custom_dns.rg_name
}

#create hub key vault

data "azurerm_client_config" "current" {
}

module "azure_keyvault_with_access_policy" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_keyvault_with_access_policy?ref=v0.0.14"

  #values to create the keyvault
  rg_name             = module.azure_hub_with_bastion.rg_name
  rg_location         = var.rg_location
  keyvault_name       = local.keyvault_name
  azure_ad_tenant_id  = data.azurerm_client_config.current.tenant_id
  lab_admin_object_id = data.azurerm_client_config.current.object_id
  tags                = local.cloud_tags
}

#create the Domain Controller
module "on_prem_dc" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_guest_server_2016_dc?ref=v0.0.14"

  rg_name                       = module.azure_spoke_with_custom_dns.rg_name
  rg_location                   = var.rg_location
  vm_name                       = var.dc_vm_name
  subnet_id                     = module.azure_hub_with_bastion.gateway_subnet_id
  vm_sku                        = "Standard_B2ms"
  key_vault_id                  = module.azure_keyvault_with_access_policy.keyvault_id
  active_directory_domain       = var.ad_domain_fullname
  active_directory_netbios_name = var.ad_domain_netbios
  private_ip_address            = var.dc_private_ip
}

#deploy a VM to use for ADFS
module "adfs_vm" {
  source = "github.com/jchancellor-ms/terraform//modules/azure_guest_server_multiversion_plain_w_domain_join?ref=v0.0.14"

  rg_name           = module.azure_spoke_with_custom_dns.rg_name
  rg_location       = var.rg_location
  vm_name           = var.adfs_vm_name
  subnet_id         = module.azure_hub_with_bastion.gateway_subnet_id
  vm_sku            = "Standard_B2ms"
  key_vault_id      = module.azure_keyvault_with_access_policy.keyvault_id
  os_version_sku    = var.adfs_os_version_sku
  ou_path           = ""
  ad_domain_netbios = var.ad_domain_netbios

  depends_on = [
    module.on_prem_dc
  ]
}

#TODO: Add custom script deployments to deploy and configure ADFS