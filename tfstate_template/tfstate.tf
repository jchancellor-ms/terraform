module "azure_terraform_state_setup" {
    source = "github.com/jchancellor-ms/terraform//modules/azure_terraform_state_setup?ref=v0.0.1"
    
    rg_name = var.rg_name
    rg_location = var.rg_location
    tags = var.tags
    state_container_name = var.state_container_name
    tfstate_keyvault_name = var.tfstate_keyvault_name
}

variable "rg_name" {
    type = string
    description = "Resource Group Name where Bastion and the associated public ip are being deployed"
}
variable "rg_location" {
    type = string
    description = "Resource Group location"
    default = "westus2"
}

variable "tags" {
    type = map(string)
    description = "List of the tags that will be assigned to each resource"
}

variable "state_container_name" {
    type = string
    description = "Azure resouuce name assigned to the container for the terraform state files"
}

variable "tfstate_keyvault_name" {
    type = string
    description = "Azure resouuce name assigned to the keyvault for terraform related secrets"
}
