
terraform {
  backend "azurerm" {
    resource_group_name  = remote-state
    storage_account_name = "atsg"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}


locals {

  common_tags = {
    Owner            = var.teamname
    service          = var.servicename
    terraformversion = var.terraformversion
    time             = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = local.common_tags
}






output "resourcegroup_name" {
  value = azurerm_resource_group.rg.name
}
/*
#First convert into dot format

terraform graph > mytf.dot

#To view in the browser

terraform graph | dot -Tsvg > mytf.svg


###to save terraform to a plan file

terraform plan -out=path

*/

