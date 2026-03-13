resource "azurerm_redis_cache" "redis" {

  name                = var.redis_name
  location            = var.location
  resource_group_name = var.rg_name

  capacity = 1
  family   = "C"
  sku_name = var.sku_name
}