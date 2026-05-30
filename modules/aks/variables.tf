variable "kubernetes_clusters" {
  description = "Map of AKS clusters to create"
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    
    default_node_pool = object({
      name       = string
      node_count = number
      vm_size    = string
    })

    identity = object({
      type = string
    })

    network_profile = optional(object({
      network_plugin = string
      load_balancer_sku = optional(string, "standard")
    }))

    tags = optional(map(string), {})
  }))
}
