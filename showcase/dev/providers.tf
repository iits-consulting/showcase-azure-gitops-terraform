provider "azurerm" {
  features {}
  subscription_id = var.ARM_SUBSCRIPTION_ID
  tenant_id       = var.ARM_TENANT_ID
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8scluster.kube_config.0.host
  username               = azurerm_kubernetes_cluster.k8scluster.kube_config.0.username
  password               = azurerm_kubernetes_cluster.k8scluster.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.k8scluster.kube_config.0.host
    username               = azurerm_kubernetes_cluster.k8scluster.kube_config.0.username
    password               = azurerm_kubernetes_cluster.k8scluster.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate)
  }
}