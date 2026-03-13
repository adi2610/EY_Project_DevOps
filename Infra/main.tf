module "resource_group" {

  source = "./modules/resource-group"

  rg_name   = "rg-devops-platform"
  location  = var.location
}

module "vnet" {

  source = "./modules/vnet"

  vnet_name = "vnet-devops"
  location  = var.location
  rg_name   = module.resource_group.rg_name
}

module "acr" {

  source = "./modules/acr"

  acr_name  = "acrdevops001"
  location  = var.location
  rg_name   = module.resource_group.rg_name
}

module "aks" {

  source = "./modules/aks"

  cluster_name = "aks-devops"
  location     = var.location
  rg_name      = module.resource_group.rg_name
  subnet_id    = module.vnet.aks_subnet_id
  node_count   = var.aks_node_count
  vm_size      = var.aks_vm_size
}

module "keyvault" {

  source = "./modules/keyvault"

  kv_name  = "kv-devops-secure"
  location = var.location
  rg_name  = module.resource_group.rg_name
}

module "redis" {

  source = "./modules/redis"

  redis_name = "redis-devops"
  location   = var.location
  rg_name    = module.resource_group.rg_name
}

module "monitoring" {

  source = "./modules/monitoring"

  workspace_name = "law-devops-monitor"
  location       = var.location
  rg_name        = module.resource_group.rg_name
}