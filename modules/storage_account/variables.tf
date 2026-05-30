variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type = map(object({
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    network_rules = optional(object({
      default_action = string
      ip_rules       = optional(list(string), [])
      bypass         = optional(list(string), ["AzureServices"])
    }))
    tags = optional(map(string), {})
  }))
}
