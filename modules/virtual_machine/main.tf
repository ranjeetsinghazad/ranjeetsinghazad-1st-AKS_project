resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.virtual_machines

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  disable_password_authentication = false # Only for demo purposes

  network_interface_ids = [
    each.value.network_interface_id,
  ]

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  tags = each.value.tags
}

# Demonstrating dynamic block with Managed Disks (Data Disks)
resource "azurerm_managed_disk" "data_disk" {
  for_each = {
    for disk in flatten([
      for vm_key, vm in var.virtual_machines : [
        for disk_key, disk in vm.data_disks : {
          vm_key    = vm_key
          disk_key  = disk_key
          config    = disk
          location  = vm.location
          rg_name   = vm.resource_group_name
        }
      ]
    ]) : "${disk.vm_key}-${disk.disk_key}" => disk
  }

  name                 = "${each.value.vm_key}-${each.value.disk_key}"
  location             = each.value.location
  resource_group_name  = each.value.rg_name
  storage_account_type = each.value.config.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.config.disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachment" {
  for_each = azurerm_managed_disk.data_disk

  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm[split("-", each.key)[0]].id
  lun                = var.virtual_machines[split("-", each.key)[0]].data_disks[split("-", each.key)[1]].lun
  caching            = var.virtual_machines[split("-", each.key)[0]].data_disks[split("-", each.key)[1]].caching
}
