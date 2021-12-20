#Module deploys a hub with vpn, firewall, and bastion subnets as well as two spare subnets for things like appGW if needed
#create a vnet for the hub configuration
resource "azurerm_resource_group" "hub_rg" {
  name     = var.rg_name
  location = var.rg_location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub_network" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  address_space       = var.vnet_address_space
  tags                = var.tags
}

#create a gateway subnet
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.hub_network.name
  resource_group_name  = azurerm_resource_group.hub_rg.name
  address_prefixes     = var.gateway_subnet_prefix
}

#create a firewall subnet
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.hub_network.name
  resource_group_name  = azurerm_resource_group.hub_rg.name
  address_prefixes     = var.firewall_subnet_prefix
}


#create a bastion subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.hub_network.name
  resource_group_name  = azurerm_resource_group.hub_rg.name
  address_prefixes     = var.bastion_subnet_prefix
}

resource "azurerm_subnet" "dc_subnet" {
  name                 = "DCSubnet"
  virtual_network_name = azurerm_virtual_network.hub_network.name
  resource_group_name  = azurerm_resource_group.hub_rg.name
  address_prefixes     = var.dc_subnet_prefix
}