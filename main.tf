terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.25.1"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "random_id" "rng" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

resource "linode_instance" "terraform1" {
  image           = "linode/kali"
  label           = "tf-${var.region}-${random_id.rng.hex}"
  group           = "Terraform"
  region          = var.region
  type            = "g6-nanode-1"
  authorized_keys = var.authorized_keys
  root_pass       = var.root_password


  connection {
    type = "ssh"
    user = "root"
    # password = var.root_password
    host  = self.ip_address
    agent = true
  }

  provisioner "file" {
    source      = "tailscale_setup.sh"
    destination = "/tmp/tailscale_setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo tf-${var.region}-${random_id.rng.hex} > /tmp/hostname",
      "echo ${var.tailscale_key} > /tmp/ts",
      "chmod +x /tmp/tailscale_setup.sh",
      "/tmp/tailscale_setup.sh",
    ]
  }

  provisioner "remote-exec" {
    when       = destroy
    on_failure = continue
    inline     = ["tailscale logout"]
  }
}
