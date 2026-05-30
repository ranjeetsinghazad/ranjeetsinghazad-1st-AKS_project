output "vnets" {
  description = "The full VNET objects"
  value       = azurerm_virtual_network.vnet
}

output "subnets" {
  description = "The full subnet objects"
  value       = azurerm_subnet.subnet
}
