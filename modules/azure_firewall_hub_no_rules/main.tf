
#firewall errors if not installed in the same resource group as the vnet with the firewall subnet
#passing the resource group details in as a variable and creating a manual depends on reference

resource "azurerm_public_ip" "firewall_pip" {
  name                = var.firewall_pip_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  availability_zone   = "No-Zone"

  allocation_method = "Static"
  sku               = "Standard"
  tags              = var.tags
}

resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  private_ip_ranges   = ["IANAPrivateRanges", ]
  tags                = var.tags

  ip_configuration {
    name                 = "firewall-ipconfiguration1"
    subnet_id            = var.hub_vnet_firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }
}

#configure the firewall to send logs to a log analytics workspace
resource "azurerm_monitor_diagnostic_setting" "firewall_metrics" {
  name                       = "${var.firewall_name}-diagnostic-setting"
  target_resource_id         = azurerm_firewall.firewall.id
  log_analytics_workspace_id = var.log_analytics_id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}