variable "ssh_keys"           { type = "list" }
variable "digitalocean_token" {}
variable "username" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

# Create a web server
resource "digitalocean_droplet" "elixir-build-box" {
  image  = "ubuntu-16-04-x64"
  name   = "elixir-build-box"
  region = "nyc2"
  size   = "1gb"
  ssh_keys = ["${var.ssh_keys}"]

  provisioner "remote-exec" {
    script = "provision.sh"
  }
}

resource "null_resource" "build" {
  triggers {
    build_box = "${digitalocean_droplet.elixir-build-box.id}"
  }

  connection {
    type = "ssh"
    host = "${digitalocean_droplet.elixir-build-box.ipv4_address}"
    user = "${var.username}"
  }

  provisioner "local-exec" {
    command = "cd .. && git archive --format=tar master | gzip > ./package.tar.gz"
  }

  provisioner "file" {
    source = "../package.tar.gz"
    destination = "/tmp/package.tar.gz"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /app",
      "tar -C /app -xvzf /tmp/package.tar.gz",
      "cd /app",
      "mix deps.get",
      "MIX_ENV=prod mix release --env=prod",
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.username}@${digitalocean_droplet.elixir-build-box.ipv4_address}:/app/_build/prod/rel/enumerest/releases/0.1.0/enumerest.tar.gz ../"
  }
}
