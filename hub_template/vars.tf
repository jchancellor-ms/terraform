variable "hub_vnet_name" {
  type        = string
  description = "The azure resource name for the hub vnet"
}
variable "vnet_address_space" {
  type        = list(string)
  description = "List of CIDR ranges assigned to the hub VNET.  Typically one larger range."
}
variable "rg_name" {
  type        = string
  description = "The azure resource name for the resource group"
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

variable "tags" {
  type        = map(string)
  description = "List of the tags that will be assigned to each resource"
}

variable "bastion_pip_name" {
  type        = string
  description = "Azure resouuce name assigned to the bastion public ip"
}
variable "bastion_name" {
  type        = string
  description = "Azure resouuce name assigned to the bastion instance"
}

variable "firewall_sku_tier" {
  type        = string
  description = "Firewall Sku Tier - allowed values are Standard and Premium"
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "Value must be Standard or Premium."
  }
}

variable "firewall_pip_name" {
  type        = string
  description = "Azure resouuce name assigned to the firewall public ip"
}

variable "firewall_name" {
  type        = string
  description = "Azure resouuce name assigned to the firewall"
}

variable "log_analytics_id" {
  type        = string
  description = "The full resource id for the log analytics workspace where the firewall will send logs"
}

variable "peer_csv_filename" {
  type        = string
  description = "Filename with spoke peering information"
}