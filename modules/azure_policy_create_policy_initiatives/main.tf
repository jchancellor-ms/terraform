#create each policy initiative configured in the definition file

locals {
  subscription_initiatives     = { for initiative in var.initiative_details : initiative.display_name => initiative if initiative.scope == "subscription" }
  management_group_initiatives = { for initiative in var.initiative_details : initiative.display_name => initiative if initiative.scope == "management_group" }

  /*  
  null_policies = {}
  management_group_policies = (var.scope == "management_group" ? local.policies : local.null_policies)
  subscription_policies = (var.scope == "subscription" ? local.policies : local.null_policies)

  */
}

#if the initiative has a management group scope call the management group initiative creation
#if the initiative has a subscription scope calle the subscription initiative creation


module "create_policy_initiative_management_group" {
  source = "../azure_policy_create_single_initiative_management_group"

  for_each = local.management_group_initiatives

  initiative_definition = each.value
}

module "create_policy_initiative_subscription" {
  source = "../azure_policy_create_single_initiative_subscription"

  for_each = local.subscription_initiatives

  initiative_definition = each.value
}