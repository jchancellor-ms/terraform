output "firewall_id" {
  value = module.azure_hub_with_firewall_and_bastion.firewall_id
}

output "firewall_private_ip_address" {
  value = module.azure_hub_with_firewall_and_bastion.firewall_private_ip_address
}

output "firewall_public_ip" {
  value = module.azure_hub_with_firewall_and_bastion.firewall_public_ip
}

output "firewall_name" {
  value = module.azure_hub_with_firewall_and_bastion.firewall_name
}

output "hub_vnet_id" {
  value = module.azure_hub_with_firewall_and_bastion.vnet_id
}

output "hub_vnet_name" {
  value = module.azure_hub_with_firewall_and_bastion.vnet_name
}

output "rg_name" {
  value = module.azure_hub_with_firewall_and_bastion.rg_name
}

output "web_subnet_prefix" {
  value = module.azure_spoke_with_custom_dns.web_subnet_prefix
}

output "data_subnet_prefix" {
  value = module.azure_spoke_with_custom_dns.data_subnet_prefix
}
