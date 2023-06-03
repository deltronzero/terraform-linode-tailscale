output "server_name" { value = try(linode_instance.terraform1.label,null) }
output "public_ip" { value = try(linode_instance.terraform1.ip_address,null) }