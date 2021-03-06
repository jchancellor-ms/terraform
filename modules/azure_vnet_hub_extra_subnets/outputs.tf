output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
}

output "firewall_subnet_id" {
  value = azurerm_subnet.firewall_subnet.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}

output "dc_subnet_id" {
  value = azurerm_subnet.dc_subnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.hub_network.id
}

output "vnet_name" {
  value = azurerm_virtual_network.hub_network.name
}

output "rg_name" {
  value = azurerm_resource_group.hub_rg.name
}

output "rg_id" {
  value = azurerm_resource_group.hub_rg.id
}