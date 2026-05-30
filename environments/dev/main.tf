module "resource_groups" {
  source          = "../../modules/resource_group"
  resource_groups = var.rg_config
}

module "networking" {
  for_each            = var.networking_config
  source              = "../../modules/networking"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  vnet_name           = each.key
  address_space       = each.value.address_space
  subnets             = each.value.subnets
  tags                = each.value.tags
  depends_on          = [module.resource_groups]
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_config
  name                = "${each.key}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.networking[each.value.vnet_name].subnets[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [module.resource_groups, module.networking]
}

module "virtual_machines" {
  source = "../../modules/virtual_machine"
  virtual_machines = {
    for k, v in var.vm_config : k => merge(v, {
      network_interface_id = azurerm_network_interface.nic[k].id
    })
  }
  depends_on = [module.resource_groups, azurerm_network_interface.nic]
}

module "storage_accounts" {
  source           = "../../modules/storage_account"
  storage_accounts = var.sa_config
  depends_on       = [module.resource_groups]
}

module "acr" {
  source               = "../../modules/acr"
  container_registries = var.acr_config
  depends_on           = [module.resource_groups]
}

module "aks" {
  source              = "../../modules/aks"
  kubernetes_clusters = var.aks_config
  depends_on          = [module.resource_groups]
}
