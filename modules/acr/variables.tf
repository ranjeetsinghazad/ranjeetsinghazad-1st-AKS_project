variable "container_registries" {
  description = "Map of Azure Container Registries to create"
  type = map(object({
    resource_group_name = string
    location            = string
    sku                 = string # Basic, Standard, Premium
    admin_enabled       = optional(bool, false)
    tags                = optional(map(string), {})
  }))
}
