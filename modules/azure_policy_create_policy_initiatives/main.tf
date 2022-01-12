#create each policy initiative configured in the definition file

locals {
 initiatives = { for initiative in var.initiative_details: initiative.display_name => initiative }
 
}

module "create_policy_initiative" {
    source = "../azure_policy_create_single_initiative"

    for_each = local.initiatives

    initiative_definition = each.value
}