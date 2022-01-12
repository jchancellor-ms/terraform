output "custom_policies" {
    value = local.policies
    #value = var.policy_definitions
}


output "github_repo" {
    value = module.custom_policy_creation
}
