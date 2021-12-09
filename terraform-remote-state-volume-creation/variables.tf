variable "context" {
  default = "showcase"
  description = "groups stages into logical context"
}

variable "stage" {
  default = "dev"
  description = "stage name for the current context"
}

variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_TENANT_ID" {}