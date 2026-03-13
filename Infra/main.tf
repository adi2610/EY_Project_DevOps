locals {

  common_tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
    managed_by  = "terraform"
  }

}

# --------------------------------------------------
# RESOURCE GROUP
# --------------------------------------------------

module "resource_group" {

  source = "./modules/resource-group"

  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location

  tags = local.common_tags
}

# --------------------------------------------------
# MONITORING
# --------------------------------------------------

module "monitoring" {

  source = "./modules/monitoring"

  workspace_name   = "${var.project_name}-${var.environment}-law"
  appinsights_name = "${var.project_name}-${var.environment}-appi"

  location            = var.location
  resource_group_name = module.resource_group.name

  tags = local.common_tags
}

# --------------------------------------------------
# NETWORK
# --------------------------------------------------

module "vnet" {

  source = "./modules/vnet"

  name                = "${var.project_name}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = module.resource_group.name

  address_space = var.vnet_address_space

  aks_subnet_prefix             = var.aks_subnet_prefix
  private_endpoint_subnet_prefix = var.private_endpoint_subnet_prefix

  tags = local.common_tags
}

# --------------------------------------------------
# CONTAINER REGISTRY
# --------------------------------------------------

module "acr" {

  source = "./modules/acr"

  name                = "${var.project_name}${var.environment}acr"
  location            = var.location
  resource_group_name = module.resource_group.name

  tags = local.common_tags
}

# --------------------------------------------------
# KEY VAULT
# --------------------------------------------------

module "keyvault" {

  source = "./modules/keyvault"

  name                = "${var.project_name}-${var.environment}-kv"
  location            = var.location
  resource_group_name = module.resource_group.name

  tenant_id = var.tenant_id

  tags = local.common_tags
}

# --------------------------------------------------
# REDIS CACHE
# --------------------------------------------------

module "redis" {

  source = "./modules/redis"

  name                = "${var.project_name}-${var.environment}-redis"
  location            = var.location
  resource_group_name = module.resource_group.name

  tags = local.common_tags
}

# --------------------------------------------------
# SQL DATABASE
# --------------------------------------------------

module "sql" {

  source = "./modules/sql"

  sql_server_name   = "${var.project_name}-${var.environment}-sql"
  sql_database_name = "${var.project_name}-db"

  resource_group_name = module.resource_group.name
  location            = var.location

  admin_login    = var.sql_admin_username
  admin_password = var.sql_admin_password

  aad_admin_object_id = var.aad_admin_object_id
  tenant_id           = var.tenant_id

  private_endpoint_subnet_id = module.vnet.private_endpoint_subnet_id

  log_analytics_workspace_id = module.monitoring.workspace_id

  tags = local.common_tags
}

# --------------------------------------------------
# AKS CLUSTER
# --------------------------------------------------

module "aks" {

  source = "./modules/aks"

  cluster_name = "${var.project_name}-${var.environment}-aks"

  resource_group_name = module.resource_group.name
  location            = var.location

  subnet_id = module.vnet.aks_subnet_id

  vm_size    = var.aks_vm_size
  node_count = var.aks_node_count
  min_nodes  = var.aks_min_nodes
  max_nodes  = var.aks_max_nodes

  log_analytics_workspace_id = module.monitoring.workspace_id

  tags = local.common_tags
}