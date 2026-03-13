variable "sql_server_name" {
  description = "Name of SQL Server"
  type        = string
}

variable "sql_database_name" {
  description = "Database name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_login" {
  description = "SQL admin login"
  type        = string
}

variable "admin_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}

variable "aad_admin_object_id" {
  description = "Azure AD admin object ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "sku_name" {
  description = "Database SKU"
  type        = string
  default     = "GP_S_Gen5_2"
}

variable "max_size_gb" {
  description = "Database max size"
  type        = number
  default     = 32
}

variable "log_analytics_workspace_id" {
  description = "Log analytics workspace"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet for private endpoint"
  type        = string
}

variable "tags" {
  type = map(string)
}