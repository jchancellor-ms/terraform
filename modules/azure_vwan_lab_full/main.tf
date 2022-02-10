resource "random_string" "namestring" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

locals {
  la_workspace_name = "loganalytics-vwan-hub-lab-${random_string.namestring.result}"
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

  source = "../azure_vwan_lab_site"

  site_root                = random_string.namestring.result
  rg_location              = "westus2"
  tags                     = local.cloud_tags
  vwan_id                  = azurerm_virtual_wan.lab_vwan.id
  vwan_hub_address_prefix  = "10.100.0.0/23"
  vwan_site_index          = "1"
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
  vwan_hub_route_table_id  = data.azurerm_virtual_hub.site1-hub.default_route_table_id #azurerm_virtual_hub_route_table.hub1-routetable.id
  vwan_rg_name             = azurerm_resource_group.root_hub_rg.name

  depends_on = [
    module.root_log_analytics
  ]
}


#Site 2
module "azure_vwan_lab_site_2" {

  source                   = "../azure_vwan_lab_site"
  site_root                = random_string.namestring.result
  rg_location              = "westus3"
  tags                     = local.cloud_tags
  vwan_id                  = azurerm_virtual_wan.lab_vwan.id
  vwan_hub_address_prefix  = "10.200.0.0/23"
  vwan_site_index          = "2"
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
  vwan_hub_route_table_id  = data.azurerm_virtual_hub.site2-hub.default_route_table_id #azurerm_virtual_hub_route_table.hub2-routetable.id
  vwan_rg_name             = azurerm_resource_group.root_hub_rg.name

  depends_on = [
    module.root_log_analytics
  ]
}

#Firewall rules
#policy
resource "azurerm_firewall_network_rule_collection" "site1-to-site2" {
  name                = "site1-to-site2"
  azure_firewall_name = module.azure_vwan_lab_site_1.firewall_name
  resource_group_name = module.azure_vwan_lab_site_1.hub_rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "default traffic 1 to 2"

    source_addresses = module.azure_vwan_lab_site_1.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_site_2.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }

  rule {
    name = "default traffic 2 to 1"

    source_addresses = module.azure_vwan_lab_site_2.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_site_1.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }

  /*
  rule {
    name = "fw to fw"

    source_addresses = [module.azure_vwan_lab_site_1.firewall_private_ip_address]

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = [module.azure_vwan_lab_site_2.firewall_private_ip_address]

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }
  */
}

resource "azurerm_firewall_network_rule_collection" "site2-to-site1" {
  name                = "site2-to-site1"
  azure_firewall_name = module.azure_vwan_lab_site_2.firewall_name
  resource_group_name = module.azure_vwan_lab_site_2.hub_rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "default traffic 2 to 1"

    source_addresses = module.azure_vwan_lab_site_2.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_site_1.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }

  rule {
    name = "default traffic 1 to 2"

    source_addresses = module.azure_vwan_lab_site_1.web_subnet_prefix

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = module.azure_vwan_lab_site_2.web_subnet_prefix

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }

  /*
  rule {
    name = "fw to fw"

    source_addresses = [module.azure_vwan_lab_site_2.firewall_private_ip_address]

    destination_ports = [
      "3389", "22", "80", "443",
    ]

    destination_addresses = [module.azure_vwan_lab_site_1.firewall_private_ip_address]

    protocols = [
      "TCP",
      "UDP",
      "ICMP",
    ]
  }
  */
}

data "azurerm_virtual_hub" "site1-hub" {
  name                = module.azure_vwan_lab_site_1.vwan_hub_name
  resource_group_name = azurerm_resource_group.root_hub_rg.name
}

data "azurerm_virtual_hub" "site2-hub" {
  name                = module.azure_vwan_lab_site_2.vwan_hub_name
  resource_group_name = azurerm_resource_group.root_hub_rg.name
}

/*
#add route table and routes
resource "azurerm_virtual_hub_route_table" "hub1-routetable" {
  name           = "vwan-hub1-routetable-${random_string.namestring.result}"
  virtual_hub_id = module.azure_vwan_lab_site_1.vwan_hub_id
  labels         = ["vwan-hub1"]
}

resource "azurerm_virtual_hub_route_table" "hub2-routetable" {
  name           = "vwan-hub2-routetable-${random_string.namestring.result}"
  virtual_hub_id = module.azure_vwan_lab_site_2.vwan_hub_id
  labels         = ["vwan-hub2"]
}
*/
resource "azurerm_virtual_hub_route_table_route" "hub1-connection1" {
  route_table_id = data.azurerm_virtual_hub.site1-hub.default_route_table_id

  name              = "classic-nva-hub-1"
  destinations_type = "CIDR"
  destinations      = ["10.110.0.0/16", "10.111.0.0/16"]
  next_hop_type     = "ResourceId"
  next_hop          = module.azure_vwan_lab_site_1.virtual_hub_connection_id
}


resource "azurerm_virtual_hub_route_table_route" "hub2-connection1" {
  route_table_id = data.azurerm_virtual_hub.site2-hub.default_route_table_id

  name              = "classic-nva-hub-2"
  destinations_type = "CIDR"
  destinations      = ["10.210.0.0/16", "10.211.0.0/16"]
  next_hop_type     = "ResourceId"
  next_hop          = module.azure_vwan_lab_site_2.virtual_hub_connection_id
}

resource "azurerm_virtual_hub_route_table_route" "hub2-connection2" {
  route_table_id = data.azurerm_virtual_hub.site2-hub.default_route_table_id

  name              = "classic-nva-hub-1-1"
  destinations_type = "CIDR"
  destinations      = ["10.110.0.0/16", "10.111.0.0/16"]
  next_hop_type     = "ResourceId"
  next_hop          = module.azure_vwan_lab_site_1.virtual_hub_connection_id
}


resource "azurerm_virtual_hub_route_table_route" "hub1-connection2" {
  route_table_id = data.azurerm_virtual_hub.site1-hub.default_route_table_id

  name              = "classic-nva-hub-2-2"
  destinations_type = "CIDR"
  destinations      = ["10.210.0.0/16", "10.211.0.0/16"]
  next_hop_type     = "ResourceId"
  next_hop          = module.azure_vwan_lab_site_2.virtual_hub_connection_id
}

