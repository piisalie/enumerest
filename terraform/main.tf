variable "ssh_keys"           { type = "list" }
variable "digitalocean_token" {}

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
