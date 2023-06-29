resource "azurerm_resource_group" "tfstate" {
  name     = "${var.context}-${var.stage}-tfstate"
  location = "Germany West Central"
}

resource "azurerm_storage_account" "account" {
  name                     = "${var.context}${var.stage}account"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.context}-${var.stage}-container"
  storage_account_name  = azurerm_storage_account.account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "infrastructure" {
  name                   = "${var.context}-${var.stage}-infrastructure-tfstate"
  storage_account_name   = azurerm_storage_account.account.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
}

resource "azurerm_storage_blob" "kubernetes" {
  name                   = "${var.context}-${var.stage}-kubernetes-tfstate"
  storage_account_name   = azurerm_storage_account.account.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
}
