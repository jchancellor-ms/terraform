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






