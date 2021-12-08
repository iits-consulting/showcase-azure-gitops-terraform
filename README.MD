- # Terraform
source env-variables.sh

# Access Argocd
-  Public IP = "kubectl -n argocd get svc argocd-server"
-  Password= "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d"