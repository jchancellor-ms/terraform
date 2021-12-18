variable "hub_vnet_name" {
  type        = string
  description = "The azure resource name for the hub virtual network being peered"
}

variable "hub_vnet_id" {
  type        = string
  description = "The full azure resource id for the hub virtual network being peered"
}

variable "spoke_vnet_name" {
  type        = string
  description = "The azure resource name for the spoke virtual network sourcing the peer"
}

variable "spoke_rg_name" {
  type        = string
  description = "The azure resource group name where the spoke vnet and peering will be located"
}
