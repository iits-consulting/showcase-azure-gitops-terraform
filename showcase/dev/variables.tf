variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_TENANT_ID" {}
variable "stage" {
  default = "dev"
}

variable "context" {
  default = "showcase"
}

locals {
  tags = {
    Environment = var.stage
  }
}