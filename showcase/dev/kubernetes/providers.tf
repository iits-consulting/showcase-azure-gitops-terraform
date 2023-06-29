provider "azurerm" {
  features {}
  subscription_id = var.ARM_SUBSCRIPTION_ID
  tenant_id       = var.ARM_TENANT_ID
}

provider "kubernetes" {
  host = data.azurerm_key_vault_secret.stage_secrets["host"].value
  username = data.azurerm_key_vault_secret.stage_secrets["username"].value
  password = data.azurerm_key_vault_secret.stage_secrets["password"].value
  client_certificate = data.azurerm_key_vault_secret.stage_secrets["client-certificate"].value
  client_key = data.azurerm_key_vault_secret.stage_secrets["client-key"].value
  cluster_ca_certificate = data.azurerm_key_vault_secret.stage_secrets["cluster-ca-certificate"].value
}

provider "helm" {
  kubernetes {
    host = data.azurerm_key_vault_secret.stage_secrets["host"].value
    username = data.azurerm_key_vault_secret.stage_secrets["username"].value
    password = data.azurerm_key_vault_secret.stage_secrets["password"].value
    client_certificate = data.azurerm_key_vault_secret.stage_secrets["client-certificate"].value
    client_key = data.azurerm_key_vault_secret.stage_secrets["client-key"].value
    cluster_ca_certificate = data.azurerm_key_vault_secret.stage_secrets["cluster-ca-certificate"].value
  }
}