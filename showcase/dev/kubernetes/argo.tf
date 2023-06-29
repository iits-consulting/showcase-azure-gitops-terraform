resource "kubernetes_namespace" "argocd" {
  metadata {
    name   = "argocd"
    labels = {
      name = "argocd"
    }
  }
}

resource "helm_release" "argocd" {
  depends_on            = [helm_release.custom_resource_definitions, helm_release.registry_credentials, helm_release.iits_kyverno_policies]
  name                  = "argocd"
  repository            = "https://charts.iits.tech"
  chart                 = "argocd"
  version               = local.charts.argo_version
  namespace             = "argocd"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  values                = [
    yamlencode({
      projects = {
        infrastructure-charts = {
          projectValues = {
            # Set this to enable stage $STAGE-values.yaml
            stage                = var.stage
            rootDomain          = var.root_domain_name
            traefikPublicIp         = data.azurerm_key_vault_secret.stage_secrets["traefik-public-ip"].value
          }

          git = {
            password = var.git_token
            repoUrl  = var.argocd_bootstrap_project_url
          }
        }
      }
    }
    )
  ]
}