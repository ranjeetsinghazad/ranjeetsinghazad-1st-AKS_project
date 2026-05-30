resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                     = each.key
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  tags                     = each.value.tags

  dynamic "network_rules" {
    for_each = each.value.network_rules != null ? [each.value.network_rules] : []
    content {
      default_action = network_rules.value.default_action
      ip_rules       = network_rules.value.ip_rules
      bypass         = network_rules.value.bypass
    }
  }
}
