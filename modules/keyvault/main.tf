resource "azurerm_key_vault" "kv" {

  name                = var.kv_name
  location            = var.location
  resource_group_name = var.rg_name

  tenant_id = var.tenant_id
  sku_name  = "standard"

  purge_protection_enabled = true
}