module "azure_terraform_state_setup" {
    source = "github.com/jchancellor-ms/terraform//modules/azure_terraform_state_setup"
    
    rg_name = var.rg_name
    rg_location = var.rg_location
    tags = var.tags
    state_container_name = var.state_container_name
    tfstate_keyvault_name = var.tfstate_keyvault_name
}