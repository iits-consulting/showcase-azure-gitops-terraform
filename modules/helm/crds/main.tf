resource "helm_release" "crds" {
  name                  = "crds"
  repository            = "https://iits-consulting.github.io/crds-chart"
  chart                 = "crds"
  version               = var.chart_version
  namespace             = var.namespace
  create_namespace      = true
  render_subchart_notes = true
  dependency_update     = true
}
