provider "digitalocean" {
  token = "c314267eedcb48e6cff091982a48c559621292ba7d717dbc75fb2b834d71c7d4"
}


resource "digitalocean_droplet" "nginx_droplet" {
  image = "ubuntu-18-04-x64"
  name = "nginx-${count.index}"
  region = "${var.region}"
  size = "512mb"
  private_networking = true
  count = 2

}


 resource "digitalocean_loadbalancer" "public" {
   name = "loadbalancer"
   region = "${var.region}"

   forwarding_rule {
     entry_port = "${var.default_port}"
     entry_protocol = "${var.http_protocol}"

     target_port = "${var.default_port}" 
     target_protocol = "${var.http_protocol}"
   }

    healthcheck {
      port = 22
      protocol = "tcp" 
    }

    droplet_ids = ["${digitalocean_droplet.nginx_droplet.*.id}"]
 }

resource "digitalocean_domain" "nginx_domain"{
  name = "orlando-nginx.com"
  ip_address = "${digitalocean_loadbalancer.public.ip}"

}

resource "digitalocean_record" "CNAME-www" {
  domain = "${digitalocean_domain.nginx_domain.name}"
  type = "CNAME"
  name = "www"
  value = "@"
}