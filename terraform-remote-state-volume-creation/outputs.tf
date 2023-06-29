
output "backend_config" {
  value = <<EOT
    # infrastructure
    backend "azurerm" {
      resource_group_name  = "${azurerm_resource_group.tfstate.name}"
      storage_account_name = "${azurerm_storage_account.account.name}"
      container_name       = "${azurerm_storage_container.container.name}"
      key                  = "${azurerm_storage_blob.infrastructure.name}"
    }
    #kubernetes
    backend "azurerm" {
      resource_group_name  = "${azurerm_resource_group.tfstate.name}"
      storage_account_name = "${azurerm_storage_account.account.name}"
      container_name       = "${azurerm_storage_container.container.name}"
      key                  = "${azurerm_storage_blob.kubernetes.name}"
    }
  EOT
}