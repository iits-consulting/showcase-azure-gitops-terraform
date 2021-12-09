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
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    STAGE = var.stage
    CONTEXT = var.context
  }
}

output "get_kubectl_command" {
  value = "connect to the kubernetes cluster like this: az aks get-credentials --admin --name ${azurerm_kubernetes_cluster.k8scluster.name} --resource-group ${azurerm_resource_group.k8s.name}"
}


module "helm_crds" {
  source                        = "../../modules/helm/crds"
}

module "argocd_configuration_chart" {
  depends_on                    = [module.helm_crds]
  source                        = "../../modules/argocd/configuration_chart"
  stage_name                    = var.stage
  github_access_token           = var.github_access_token
}

module "argocd_chart" {
  depends_on                    = [module.argocd_configuration_chart]
  source                        = "../../modules/argocd/chart"
  chart_version                 = "3.26.10"
}

data "kubernetes_service" "argocd"{
  metadata {
    name = "argocd-server"
    namespace = "argocd"
  }
}

output "argocd_public_ip" {
  value = data.kubernetes_service.argocd.status
}