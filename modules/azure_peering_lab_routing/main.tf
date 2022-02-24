locals {
  target_routes       = { for routes in var.route_table.target_routes : routes.target_address_prefix => routes }
  resource_group_name = var.route_table.source_rg_name
  location            = var.route_table.source_rg_location
  route_table_name    = var.route_table.source_route_table_name
  subnet_id           = var.route_table.source_subnet_id
}


resource "azurerm_route_table" "hub" {
  name                          = local.route_table_name
  location                      = local.location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = true
  #tags                          = var.tags
}


#loop through subnets and create routes
resource "azurerm_route" "this" {
  for_each = local.target_routes

  name                   = "route_to_${each.value.target_subnet_name}"
  resource_group_name    = local.resource_group_name
  route_table_name       = azurerm_route_table.hub.name
  address_prefix         = each.value.target_address_prefix
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = each.value.next_hop
}

#required to address an issue where Azure Firewall seems to have issues with a UDR being applied.
resource "azurerm_route" "default" {

  name                = "route_to_internet"
  resource_group_name = local.resource_group_name
  route_table_name    = azurerm_route_table.hub.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"

}


resource "azurerm_subnet_route_table_association" "hub" {
  subnet_id      = local.subnet_id
  route_table_id = azurerm_route_table.hub.id

  depends_on = [
    azurerm_route.default
  ]
}