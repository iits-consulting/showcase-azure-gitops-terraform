resource "azurerm_resource_group" "k8s" {
  name     = "${var.context}-${var.stage}-k8s"
  location = "Germany West Central"
}

resource "azurerm_kubernetes_cluster" "k8scluster" {
  name                = "${var.context}-${var.stage}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = "${var.context}-${var.stage}-dns"

  default_node_pool {
    name       = "mydefault"
    node_count = 3
    vm_size    = "Standard_D3_v2"
  }

  identity {
    type = "SystemAssigned"

  }

  tags = {
    STAGE = var.stage
    CONTEXT = var.context
  }
}

resource "azurerm_public_ip" "traefik" {
  name                = "${var.context}-${var.stage}-traefik"
  location            = azurerm_kubernetes_cluster.k8scluster.location
  resource_group_name = azurerm_kubernetes_cluster.k8scluster.node_resource_group

  allocation_method = "Static"
  sku = "Standard"
  tags = {
    STAGE = var.stage
    CONTEXT = var.context
  }
}

output "get_kubectl_command" {
  value = "connect to the kubernetes cluster like this: az aks get-credentials --admin --name ${azurerm_kubernetes_cluster.k8scluster.name} --resource-group ${azurerm_resource_group.k8s.name}"
}