locals {
 policies = { for policy in var.policy_definitions: policy.name => policy if policy.type == "Custom" }
 
}


module "custom_policy_creation" {
    source = "../azure_policy_create_custom_policy/"

    for_each = local.policies

   policy_definition_name = each.value.name
   policy_definition_display_name = each.value.display_name
   policy_mode = each.value.mode
   custom_policy_github_repo = each.value.github_repo
   github_repo_branch = each.value.github_repo_branch
   policy_rule_filename = each.value.policy_rule_filename
   policy_parameters_filename = each.value.policy_parameters_filename
   policy_metadata_filename = each.value.policy_metadata_filename 

}
