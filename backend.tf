terraform {

  required_version = ">=1.5"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateprod123"
    container_name       = "tfstate"
    key                  = "{{paramters.env}}.tfstate"
  }
}