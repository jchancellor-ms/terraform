variable "datacenter" {
  type        = string
  description = "datacenter name where the content library will be created"
}

variable "datastore" {
  type        = string
  description = "datastore name where the content library will be created"
}

variable "library_name" {
  type        = string
  description = "content library name for the content library being created"
}

variable "library_description" {
  type        = string
  description = "Detailed description of the content library being created"
}