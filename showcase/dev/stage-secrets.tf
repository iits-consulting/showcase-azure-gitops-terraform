resource "azurerm_resource_group" "vault" {
  name     = "${var.context}-${var.stage}-vault"
  location = "Germany West Central"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                        = "${var.context}-${var.stage}-vault"
  location                    = azurerm_resource_group.vault.location
  resource_group_name         = azurerm_resource_group.vault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Delete",
      "Update",
      "Get",
      "List",
      "Purge",
      "Recover",
    ]

    secret_permissions = [
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Set",
    ]

    storage_permissions = [
      "Delete",
      "Update",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Set",
    ]
  }
}

locals {
  stage_secrets = tomap({
    host                   = azurerm_kubernetes_cluster.k8scluster.kube_config.0.host,
    username               = azurerm_kubernetes_cluster.k8scluster.kube_config.0.username,
    password               = azurerm_kubernetes_cluster.k8scluster.kube_config.0.password,
    client-certificate     = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate),
    client-key             = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key),
    cluster-ca-certificate = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate)
    traefik-public-ip      = azurerm_public_ip.traefik.ip_address
  })
}

resource "azurerm_key_vault_secret" "stage-secrets" {
  for_each = local.stage_secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.vault.id
  tags = {
    TENANT_ID = data.azurerm_client_config.current.tenant_id
    CREATOR     = data.azurerm_client_config.current.client_id
  }

}