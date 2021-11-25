rg_name                = "sample_hub_rg_name"
rg_location            = "westus2"
hub_vnet_name          = "sample_vnet_name"
vnet_address_space     = ["10.1.0.0/16", ]
gateway_subnet_prefix  = ["10.1.1.0/24", ]
firewall_subnet_prefix = ["10.1.2.0/24", ]
bastion_subnet_prefix  = ["10.1.3.0/24", ]
tags                   = { testtag = "testtag" }
bastion_pip_name       = "sample_bastion_pip_name"
bastion_name           = "sample_bastion_name"
firewall_sku_tier      = "Standard"
firewall_pip_name      = "sample_firewall_public_ip_name"
firewall_name          = "sample_firewall_name"
log_analytics_id       = "<put LA workspace ID here>"
release_version        = "v0.0.2"

