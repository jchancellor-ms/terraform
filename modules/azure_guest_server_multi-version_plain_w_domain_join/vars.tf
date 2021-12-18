variable "rg_name" {
  type        = string
  description = "The azure resource name for the resource group"
}
variable "rg_location" {
  type        = string
  description = "Resource Group region location"
  default     = "westus2"
}
variable "vm_name" {
  type        = string
  description = "The azure resource name for the virtual machine"
}
variable "subnet_id" {
  type        = string
  description = "The resource ID for the subnet where the virtual machine will be deployed"
}
variable "vm_sku" {
  type        = string
  description = "The sku value for the virtual machine being deployed"
}
variable "key_vault_id" {
  type        = string
  description = "The resource ID for the key vault where the virtual machine secrets will be deployed"
}

#update with allowed values for standard server OS Types
variable "os_version_sku" {
  type        = string
  description = "The sku value for the virtual machine being deployed"
  default     = "2016-Datacenter"
}

variable "ou_path" {
  type        = string
  description = "OU to put the computer object in when joining the domain"
  default     = ""
}

variable "ad_domain_netbios" {
  type        = string
  description = "The netbios name for the domain being created"
}

#variable "firewall_ip" {}