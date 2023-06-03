# terraform to setup a tailscale exit node

1. update `secret.tfvars` with correct api keys
2. `terraform apply -auto-approve -var-file=secret.tfvars`


recommended:
setup auto approving exit nodes
https://tailscale.com/kb/1018/acls/#auto-approvers-for-routes-and-exit-nodes