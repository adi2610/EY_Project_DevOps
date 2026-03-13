resource "azurerm_mssql_server" "sql_server" {

  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"

  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password

  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  azuread_administrator {

    login_username = "aad-admin"
    object_id      = var.aad_admin_object_id
    tenant_id      = var.tenant_id
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "database" {

  name      = var.sql_database_name
  server_id = azurerm_mssql_server.sql_server.id

  sku_name    = var.sku_name
  max_size_gb = var.max_size_gb

  zone_redundant = true

  auto_pause_delay_in_minutes = -1

  tags = var.tags
}

resource "azurerm_mssql_database_extended_auditing_policy" "auditing" {

  database_id = azurerm_mssql_database.database.id

  log_monitoring_enabled = true
}

resource "azurerm_mssql_server_security_alert_policy" "defender" {

  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sql_server.name

  state = "Enabled"
}

resource "azurerm_private_endpoint" "sql_private_endpoint" {

  name                = "${var.sql_server_name}-pep"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.private_endpoint_subnet_id

  private_service_connection {

    name                           = "sql-private-connection"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "sql_diagnostics" {

  name                       = "sql-diagnostics"
  target_resource_id         = azurerm_mssql_server.sql_server.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }

  enabled_log {
    category = "AutomaticTuning"
  }

  enabled_log {
    category = "QueryStoreRuntimeStatistics"
  }

  enabled_log {
    category = "QueryStoreWaitStatistics"
  }
}