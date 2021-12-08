variable "namespace" {
  default     = "crds"
  description = "the namespace to deploy"
}

variable "chart_version" {
  description = "version of charts"
  default     = "1.1.3"
}
