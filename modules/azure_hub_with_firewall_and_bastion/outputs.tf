output "firewall_id" {
    value = module.azure_firewall_hub_no_rules.firewall_id
}

output "firewall_private_ip_address" {
    value = module.azure_firewall_hub_no_rules.firewall_private_ip_address
}

output "firewall_name" {
    value = module.azure_firewall_hub_no_rules.firewall_name
}

output "firewall_public_ip" {
    value = module.azure_firewall_hub_no_rules.firewall_public_ip
}

output "vnet_id" {
    value = module.azure_vnet_hub_extra_subnets.vnet_id
}

output "rg_name" {
    value = module.azure_vnet_hub_extra_subnets.rg_name
}

output "rg_id" {
    value = module.azure_vnet_hub_extra_subnets.rg_id
}