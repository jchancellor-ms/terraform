output "web_subnet_id" {
  value = azurerm_subnet.web-subnet.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data-subnet.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke_network.id
}

output "rg_name" {
  value = azurerm_resource_group.spoke_rg.name
}

output "rg_id" {
  value = azurerm_resource_group.spoke_rg.id
}

output "web_subnet_prefix" {
  value = azurerm_subnet.web-subnet.address_prefixes
}

output "data_subnet_prefix" {
  value = azurerm_subnet.data-subnet.address_prefixes
}
