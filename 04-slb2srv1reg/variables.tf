variable "rg_name" {}

variable "pry_location" {}

variable "tags" {
  type = map(any)
}

variable "vnet_name" {}
variable "vnet_address_space" {
  type = list(any)
}
variable "vnet_subnet01" {}
variable "vnet_subnet02" {}
variable "prefix" {
  default = "tfvmex"
}