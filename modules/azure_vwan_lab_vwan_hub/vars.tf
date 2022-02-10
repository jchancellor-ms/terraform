variable "site_root" {
  description = "Unique identifier for the site elements"
}

variable "vwan_rg_location" {
  description = "Resource Group region location"
  default     = "westus2"
}

variable "vwan_rg_name" {
  description = "Resource Group name"
}

variable "tags" {
  description = "Pass through tags"
}

variable "vwan_id" {
  description = "Main virtual WAN id"
}

variable "vwan_hub_address_prefix" {
  description = "Address prefix for the VWAN hub being created"
}

variable "vwan_site_index" {
  description = "Index for this virtual wan Hub and site"
}