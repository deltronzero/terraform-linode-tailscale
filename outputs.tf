output "server_name" { value = try(linode_instance.terraform1.label,null) }
output "public_ip" { value = try(linode_instance.terraform1.ip_address,null) }

resource "local_file" "ip_inv" {
 content = templatefile("./inventory.tmpl",
 {
  cat = "terraform1",
  addr = linode_instance.terraform1.ip_address
  vars = ["ansible_python_interpreter: /usr/bin/python3",
        "ansible_user: root", format("%s: %s", "system_name",linode_instance.terraform1.label) ]
 }
 )
 filename = "./ansible/inventory/terraform1.yml"
}