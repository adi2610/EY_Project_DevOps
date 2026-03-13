resource "azurerm_kubernetes_cluster" "this" {

  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = var.cluster_name

  private_cluster_enabled = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {

    name                = "systempool"
    vm_size             = var.vm_size
    node_count          = var.node_count
    vnet_subnet_id      = var.subnet_id

    auto_scaling_enabled = true
    min_count           = var.min_nodes
    max_count           = var.max_nodes

    zones = ["1","2","3"]
  }

  network_profile {

    network_plugin = "azure"
    network_policy = "azure"

    service_cidr   = "10.2.0.0/16"
    dns_service_ip = "10.2.0.10"
  }

  oms_agent {

    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  role_based_access_control_enabled = true

  tags = var.tags
}