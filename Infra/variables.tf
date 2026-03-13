# --------------------------------------------------
# GLOBAL VARIABLES
# --------------------------------------------------

variable "project_name" {

  description = "Project name"
  type        = string
}

variable "environment" {

  description = "Deployment environment"
  type        = string
}

variable "location" {

  description = "Azure region"
  type        = string
}

variable "owner" {

  description = "Resource owner"
  type        = string
}

# --------------------------------------------------
# NETWORK VARIABLES
# --------------------------------------------------

variable "vnet_address_space" {

  description = "VNET CIDR"
  type        = list(string)
}

variable "aks_subnet_prefix" {

  description = "AKS subnet"
  type        = list(string)
}

variable "private_endpoint_subnet_prefix" {

  description = "Private endpoint subnet"
  type        = list(string)
}

# --------------------------------------------------
# AKS VARIABLES
# --------------------------------------------------

variable "aks_vm_size" {

  description = "AKS node VM size"
  type        = string
}

variable "aks_node_count" {

  description = "Initial node count"
  type        = number
}

variable "aks_min_nodes" {

  description = "Minimum nodes for autoscaling"
  type        = number
}

variable "aks_max_nodes" {

  description = "Maximum nodes for autoscaling"
  type        = number
}

# --------------------------------------------------
# SQL VARIABLES
# --------------------------------------------------

variable "sql_admin_username" {

  description = "SQL admin username"
  type        = string
}

variable "sql_admin_password" {

  description = "SQL admin password"
  type        = string
  sensitive   = true
}

# --------------------------------------------------
# AZURE AD
# --------------------------------------------------

variable "tenant_id" {

  description = "Azure AD tenant"
  type        = string
}

variable "aad_admin_object_id" {

  description = "AAD admin object id"
  type        = string
}