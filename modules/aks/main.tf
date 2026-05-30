resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.kubernetes_clusters

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix

  default_node_pool {
    name       = each.value.default_node_pool.name
    node_count = each.value.default_node_pool.node_count
    vm_size    = each.value.default_node_pool.vm_size
  }

  identity {
    type = each.value.identity.type
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin    = network_profile.value.network_plugin
      load_balancer_sku = network_profile.value.load_balancer_sku
    }
  }

  tags = each.value.tags
}
