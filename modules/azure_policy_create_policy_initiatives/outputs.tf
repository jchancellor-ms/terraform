output "policy_initiative_ids" {
    value = values(module.create_policy_initiative)[*].id
}

output "policy_initiative_name_id_map" {
    value = zipmap(values(module.create_policy_initiative)[*].display_name, values(module.create_policy_initiative)[*].id)
}