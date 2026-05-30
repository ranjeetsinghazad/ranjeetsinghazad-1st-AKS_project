terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateazad001"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
  }
}
