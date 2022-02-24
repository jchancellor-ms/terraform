locals {
  la_workspace_name = "loganalytics-hub-peering-lab-${random_string.namestring.result}"
  rg_name           = "rg-hub-peering-lab-${random_string.namestring.result}"

  cloud_tags = {
    environment = "demo"
    project     = "peering_lab"

  }
}

resource "random_string" "namestring" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

resource "azurerm_resource_group" "root_hub_rg" {
  name     = local.rg_name
  location = var.rg_location_1
  tags     = local.cloud_tags
}

module "root_log_analytics" {
  source = "../azure_log_analytics_simple"

  rg_name     = azurerm_resource_group.root_hub_rg.name
  rg_location = azurerm_resource_group.root_hub_rg.location
  la_name     = local.la_workspace_name
  tags        = local.cloud_tags
}


module "azure_vwan_lab_classic_hub_spoke_1" {

  source                   = "../azure_vwan_lab_classic_hub_spoke"
  site_root                = random_string.namestring.result
  rg_location              = var.rg_location_1
  hub_vnet_address_space   = ["10.110.0.0/16"]
  gateway_subnet_prefix    = ["10.110.1.0/24"]
  firewall_subnet_prefix   = ["10.110.2.0/24"]
  bastion_subnet_prefix    = ["10.110.3.0/24"]
  dc_subnet_prefix         = ["10.110.4.0/24"]
  spoke_vnet_address_space = ["10.111.0.0/16"]
  web_subnet_prefix        = ["10.111.1.0/24"]
  data_subnet_prefix       = ["10.111.2.0/24"]
  vm_sku                   = "Standard_B2ms"
  os_version_sku           = "2016-Datacenter"
  log_analytics_id         = module.root_log_analytics.log_analytics_id
  tags                     = local.cloud_tags
}

module "azure_vwan_lab_classic_hub_spoke_2" {

  source                   = "../azure_vwan_lab_classic_hub_spoke"
  site_root                = random_string.namestring.result
  rg_location              = var.rg_location_2
  hub_vnet_address_space   = ["10.210.0.0/16"]
  gateway_subnet_prefix    = ["10.210.1.0/24"]
  firewall_subnet_prefix   = ["10.210.2.0/24"]
  bastion_subnet_prefix    = ["10.210.3.0/24"]
  dc_subnet_prefix         = ["10.210.4.0/24"]
  spoke_vnet_address_space = ["10.211.0.0/16"]
  web_subnet_prefix        = ["10.211.1.0/24"]
  data_subnet_prefix       = ["10.211.2.0/24"]
  vm_sku                   = "Standard_B2ms"
  os_version_sku           = "2016-Datacenter"
  log_analytics_id         = module.root_log_analytics.log_analytics_id
  tags                     = local.cloud_tags
}

module "azure_vwan_lab_classic_hub_spoke_3" {

  source                   = "../azure_vwan_lab_classic_hub_spoke"
  site_root                = random_string.namestring.result
  rg_location              = var.rg_location_3
  hub_vnet_address_space   = ["10.10.0.0/16"]
  gateway_subnet_prefix    = ["10.10.1.0/24"]
  firewall_subnet_prefix   = ["10.10.2.0/24"]
  bastion_subnet_prefix    = ["10.10.3.0/24"]
  dc_subnet_prefix         = ["10.10.4.0/24"]
  spoke_vnet_address_space = ["10.11.0.0/16"]
  web_subnet_prefix        = ["10.11.1.0/24"]
  data_subnet_prefix       = ["10.11.2.0/24"]
  vm_sku                   = "Standard_B2ms"
  os_version_sku           = "2016-Datacenter"
  log_analytics_id         = module.root_log_analytics.log_analytics_id
  tags                     = local.cloud_tags
}

#create peering mesh
# hub 1 to hub 2
resource "azurerm_virtual_network_peering" "hub_1_to_2" {
  name                      = "hub-1-to-2-link"
  resource_group_name       = module.azure_vwan_lab_classic_hub_spoke_1.rg_name
  virtual_network_name      = module.azure_vwan_lab_classic_hub_spoke_1.hub_vnet_name
  remote_virtual_network_id = module.azure_vwan_lab_classic_hub_spoke_2.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_2_to_1" {
  name                      = "hub-2-to-1-link"
  resource_group_name       = module.azure_vwan_lab_classic_hub_spoke_2.rg_name
  virtual_network_name      = module.azure_vwan_lab_classic_hub_spoke_2.hub_vnet_name
  remote_virtual_network_id = module.azure_vwan_lab_classic_hub_spoke_1.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}


# hub 1 to hub 3
resource "azurerm_virtual_network_peering" "hub_1_to_3" {
  name                      = "hub-1-to-3-link"
  resource_group_name       = module.azure_vwan_lab_classic_hub_spoke_1.rg_name
  virtual_network_name      = module.azure_vwan_lab_classic_hub_spoke_1.hub_vnet_name
  remote_virtual_network_id = module.azure_vwan_lab_classic_hub_spoke_3.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_3_to_1" {
  name                      = "hub-3-to-1-link"
  resource_group_name       = module.azure_vwan_lab_classic_hub_spoke_3.rg_name
  virtual_network_name      = module.azure_vwan_lab_classic_hub_spoke_3.hub_vnet_name
  remote_virtual_network_id = module.azure_vwan_lab_classic_hub_spoke_1.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# hub 2 to hub 3
resource "azurerm_virtual_network_peering" "hub_2_to_3" {
  name                      = "hub-2-to-3-link"
  resource_group_name       = module.azure_vwan_lab_classic_hub_spoke_2.rg_name
  virtual_network_name      = module.azure_vwan_lab_classic_hub_spoke_2.hub_vnet_name
  remote_virtual_network_id = module.azure_vwan_lab_classic_hub_spoke_3.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub_3_to_2" {
  name                      = "hub-3-to-2-link"
  resource_group_name       = module.azure_vwan_lab_classic_hub_spoke_3.rg_name
  virtual_network_name      = module.azure_vwan_lab_classic_hub_spoke_3.hub_vnet_name
  remote_virtual_network_id = module.azure_vwan_lab_classic_hub_spoke_2.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}


#add routing for allowed subnets
#route table and UDR attached to hub 1 firewall subnet targeting traffic to web subnet to firewall NIC




#allow traffic from site 1 to site 2 but not site 3
resource "azurerm_firewall_network_rule_collection" "site1-to-site2" {
  name                = "site1-to-site2"
  azure_firewall_name = module.azure_vwan_lab_classic_hub_spoke_1.firewall_name
  resource_group_name = module.azure_vwan_lab_classic_hub_spoke_1.rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "default traffic 1 to 2"

    source_addresses = module.azure_vwan_lab_classic_hub_spoke_1.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_classic_hub_spoke_2.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }

  rule {
    name = "default traffic 2 to 1"

    source_addresses = module.azure_vwan_lab_classic_hub_spoke_2.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_classic_hub_spoke_1.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }
}

#allow traffic from site 1 to site 2 but not site 3
resource "azurerm_firewall_network_rule_collection" "site2-to-site1" {
  name                = "site1-to-site2"
  azure_firewall_name = module.azure_vwan_lab_classic_hub_spoke_2.firewall_name
  resource_group_name = module.azure_vwan_lab_classic_hub_spoke_2.rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "default traffic 1 to 2"

    source_addresses = module.azure_vwan_lab_classic_hub_spoke_2.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_classic_hub_spoke_1.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }

  rule {
    name = "default traffic 2 to 1"

    source_addresses = module.azure_vwan_lab_classic_hub_spoke_1.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_classic_hub_spoke_2.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }
}