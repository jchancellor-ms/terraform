variable "site_root" {
  description = "Naming root for auto-generating names"
}

variable "rg_location" {
  description = "Resource Group region location"
  default     = "westus2"
}

variable "hub_vnet_address_space" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the hub vnet"
}

variable "gateway_subnet_prefix" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the gateway subnet address space"
}

variable "firewall_subnet_prefix" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the firewall subnet address space"
}

variable "bastion_subnet_prefix" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the bastion subnet address space"
}

variable "dc_subnet_prefix" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the domain controller subnet address space"
}

variable "spoke_vnet_address_space" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the hub vnet"
}

variable "web_subnet_prefix" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the spoke web subnet address space"
}

variable "data_subnet_prefix" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the spoke data subnet address space"
}

variable "vm_sku" {
  type        = string
  description = "The sku value for the virtual machine being deployed"
}

variable "os_version_sku" {
  type        = string
  description = "The sku value for the virtual machine being deployed"
  default     = "2016-Datacenter"
}

variable "log_analytics_id" {
  type        = string
  description = "The id for the log analytics workspace being used"
}

variable "tags" {
  description = "Pass through tags"
}