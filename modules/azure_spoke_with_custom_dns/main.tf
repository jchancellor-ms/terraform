resource "azurerm_resource_group" "spoke_rg" {
  name     = var.rg_name
  location = var.rg_location
  tags     = var.tags
}

resource "azurerm_virtual_network" "spoke_network" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.spoke_rg.name
  location            = azurerm_resource_group.spoke_rg.location
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_virtual_network_dns_servers" "spoke_dns" {
  virtual_network_id = azurerm_virtual_network.spoke_network.id
  dns_servers        = var.dns_servers
}

resource "azurerm_subnet" "web-subnet" {
  name                                           = var.web_subnet_name
  virtual_network_name                           = azurerm_virtual_network.spoke_network.name
  resource_group_name                            = azurerm_resource_group.spoke_rg.name
  address_prefixes                               = var.web_subnet_prefix
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "data-subnet" {
  name                                           = var.data_subnet_name
  virtual_network_name                           = azurerm_virtual_network.spoke_network.name
  resource_group_name                            = azurerm_resource_group.spoke_rg.name
  address_prefixes                               = var.data_subnet_prefix
  enforce_private_link_endpoint_network_policies = true
}

