resource "azurerm_log_analytics_workspace" "workspace" {

  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
}