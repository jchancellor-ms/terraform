
variable "site_root" {
  description = "Unique identifier for the site elements"
}

variable "rg_location" {
  description = "Resource Group region location"
  default     = "westus2"
}

variable "tags" {
  description = "Pass through tags"
}

variable "vwan_id" {
  description = "ID for the virtual WAN"
}

variable "vwan_hub_address_prefix" {
  description = "Address prefix for the VWAN hub being created"
}

variable "vwan_site_index" {
  description = "Index for this virtual wan Hub and site"
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