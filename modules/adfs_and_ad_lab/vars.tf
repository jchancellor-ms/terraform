variable "project" {
  type        = string
  description = "The project name used to seed the tags and naming prefixes."
}
variable "hub_vnet_name" {
  type        = string
  description = "The azure resource name for the hub vnet"
}
variable "hub_vnet_address_space" {
  type        = list(string)
  description = "List of CIDR ranges assigned to the hub VNET.  Typically one larger range."
}
variable "hub_rg_name" {
  type        = string
  description = "The azure resource name for the hub resource group"
}
variable "spoke_rg_name" {
  type        = string
  description = "The azure resource name for the spoke resource group"
}
variable "rg_location" {
  description = "Resource Group region location"
  default     = "westus2"
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

variable "bastion_pip_name" {
  type        = string
  description = "Azure resouuce name assigned to the bastion public ip"
}
variable "bastion_name" {
  type        = string
  description = "Azure resouuce name assigned to the bastion instance"
}

variable "spoke_vnet_name" {
  type = string
}
variable "spoke_vnet_address_space" {
  type        = list(string)
  description = "List of CIDR ranges assigned to the spoke VNET.  Typically one larger range."
}

variable "web_subnet_name" {
  type = string
}
variable "web_subnet_prefix" {
  type = list(string)
}
variable "data_subnet_name" {
  type = string
}
variable "data_subnet_prefix" {
  type = list(string)
}
#variable "dns_servers" {}


variable "dc_vm_name" {
  type        = string
  description = "The azure resource name for the virtual machine"
}
variable "ad_domain_fullname" {
  type        = string
  description = "The full domain name for the domain being created"
}
variable "ad_domain_netbios" {
  type        = string
  description = "The netbios name for the domain being created"
}
variable "dc_private_ip" {
  type        = string
  description = "The static IP address of the domain controller which will be injected into DNS"
}

variable "adfs_vm_name" {
  type        = string
  description = "The azure resource name for the virtual machine"
}

variable "adfs_os_version_sku" {
  type        = string
  description = "The sku value for the virtual machine being deployed"
  default     = "2016-Datacenter"
}

variable "dc_subnet_prefix" {
  type        = list(string)
  description = "A list of subnet prefix CIDR values used for the domain controller subnet address space"
}