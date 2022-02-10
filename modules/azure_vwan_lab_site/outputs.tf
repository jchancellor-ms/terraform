
output "firewall_id" {
  value = module.azure_vwan_lab_classic_hub_spoke.firewall_id
}

output "firewall_private_ip_address" {
  value = module.azure_vwan_lab_classic_hub_spoke.firewall_private_ip_address
}

output "firewall_public_ip" {
  value = module.azure_vwan_lab_classic_hub_spoke.firewall_public_ip
}

output "firewall_name" {
  value = module.azure_vwan_lab_classic_hub_spoke.firewall_name
}

output "hub_rg_name" {
  value = module.azure_vwan_lab_classic_hub_spoke.rg_name
}

output "web_subnet_prefix" {
  value = var.web_subnet_prefix
}

output "virtual_hub_connection_id" {
  value = azurerm_virtual_hub_connection.vwan_to_classic_hub.id
}

output "vwan_hub_id" {
  value = module.azure_vwan_lab_vwan_hub.vwan_hub_id
}

output "vwan_hub_name" {
  value = module.azure_vwan_lab_vwan_hub.vwan_hub_name
}