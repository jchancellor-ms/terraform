
#create subscription and management group values

locals {
    subscription_initiatives = {for initiative in var.initiatives_details : initiative.display_name => initiative if initiative.scope == "subscription" }
    management_group_initiatives = {for initiative in var.initiatives_details : initiative.display_name => initiative if initiative.scope == "management_group" }
    
}

resource "azurerm_subscription_policy_assignment" "subscriptions" {
  for_each = local.subscription_initiatives
  name                 = each.value.name
  policy_definition_id = lookup(var.initiative_name_id_map, each.value.display_name)
  subscription_id      = each.value.scope_target
  display_name = each.value.display_name
  location = each.value.location

  identity {
      type = "SystemAssigned"
  }
}


resource "azurerm_subscription_policy_assignment" "management_groups" {
  for_each = local.management_group_initiatives
  name                 = each.value.name
  policy_definition_id = lookup(var.initiative_name_id_map, each.value.display_name)
  subscription_id      = each.value.scope_target
  display_name = each.value.display_name
  location = each.value.location

  identity {
      type = "SystemAssigned"
  }
}
