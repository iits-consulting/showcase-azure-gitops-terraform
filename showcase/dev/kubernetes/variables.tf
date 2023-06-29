locals {
  charts = {
    registry_creds_version        = "1.1.5"
    crds_version                  = "1.5.0"
    argo_version                  = "5.30.1-add-helm-registries"
    kyverno_version               = "1.2.0"
    iits_kyverno_policies_version = "1.4.6"
  }
}

data "azurerm_key_vault" "vault" {
  name                        = "${var.context}-${var.stage}-vault"
  resource_group_name         = "${var.context}-${var.stage}-vault"
}

data "azurerm_key_vault_secrets" "vault" {
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "stage_secrets" {
  for_each     = toset(data.azurerm_key_vault_secrets.vault.names)
  name         = each.key
  key_vault_id = data.azurerm_key_vault.vault.id
}


variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_TENANT_ID" {}
variable "stage" {
  default = "dev"
}

variable "context" {
  default = "showcase"
}


variable "argocd_bootstrap_project_url" {
  type        = string
  description = "Link to the git project which is a fork of this project here: https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory"
  validation {
    condition     = !can(regex("iits-consulting",var.argocd_bootstrap_project_url))
    error_message = "TF_VAR_argocd_bootstrap_project_url is set wrong. Please use your fork and not the iits-consulting repo"
  }
  validation {
    condition     =  can(regex("https://github.com", var.argocd_bootstrap_project_url))
    error_message = "TF_VAR_argocd_bootstrap_project_url is set wrong. Please use the https link from you fork"
  }
}

variable "dockerhub_username" {
  type        = string
  description = "Username of Docker Registry Credentials for ArgoCD"
  sensitive   = true
}

variable "dockerhub_password" {
  type        = string
  description = "Password of Docker Registry Credentials for ArgoCD"
  sensitive   = true
}

variable "root_domain_name" {
  type        = string
  description = "The public domain where everything runs."
}

variable "git_token" {
  type        = string
  description = "Git Access Token for ArgoCD"
  sensitive   = true
}
