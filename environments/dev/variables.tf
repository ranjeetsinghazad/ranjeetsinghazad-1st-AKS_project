variable "rg_config" {
  type = map(object({
    location = string
    tags     = optional(map(string), {})
  }))
}

variable "sa_config" {
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

variable "vm_config" {
  type = map(object({
    resource_group_name = string
    location            = string
    size                = string
    vnet_name           = string
    subnet_name         = string
    admin_username      = string
    admin_password      = string
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    data_disks = optional(map(object({
      lun                  = number
      disk_size_gb         = number
      storage_account_type = string
      caching              = string
    })), {})
    tags = optional(map(string), {})
  }))
}

variable "networking_config" {
  type = map(object({
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnets = map(object({
      address_prefixes = list(string)
    }))
    tags = optional(map(string), {})
  }))
}

variable "acr_config" {
  type = map(object({
    resource_group_name = string
    location            = string
    sku                 = string
    admin_enabled       = optional(bool, false)
    tags                = optional(map(string), {})
  }))
}

variable "aks_config" {
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
      network_plugin    = string
      load_balancer_sku = optional(string, "standard")
    }))
    tags = optional(map(string), {})
  }))
}
