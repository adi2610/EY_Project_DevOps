variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "rg_name" {
  description = "Resource group"
  type        = string
}

variable "subnet_id" {
  description = "AKS subnet ID"
  type        = string
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
}

variable "vm_size" {
  description = "Node VM size"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}