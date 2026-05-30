output "virtual_machines" {
  description = "The full virtual machine objects"
  value       = azurerm_linux_virtual_machine.vm
}

output "managed_disks" {
  description = "The full managed disk objects"
  value       = azurerm_managed_disk.data_disk
}
