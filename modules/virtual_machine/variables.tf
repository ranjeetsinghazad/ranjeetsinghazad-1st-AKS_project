variable "virtual_machines" {
  description = "Nested map of virtual machines and their configurations"
  type = map(object({
    resource_group_name = string
    location            = string
    size                = string
    admin_username      = string
    admin_password      = optional(string) # Best practice: use SSH keys for Linux, but keeping it simple for demo
    network_interface_id = string
    
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
