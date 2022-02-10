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

output "rg_name" {
  value = module.azure_hub_with_firewall_and_bastion.rg_name
}