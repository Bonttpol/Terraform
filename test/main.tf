resource "yandex_vpc_network" "network-1" {
  name = "net1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

module "inst1" {
  source    = "../modules/"
  name      = "inst-1"
  image     = "lamp"
  subnet_id = yandex_vpc_subnet.subnet-1.id
}

module "inst2" {
  source    = "../modules/"
  image     = "lamp"
  name      = "inst-2"
  subnet_id = yandex_vpc_subnet.subnet-1.id
}

# LB

data "yandex_compute_instance" "data_insti1" {
  name = "inst-1"
}

data "yandex_compute_instance" "data_insti2" {
  name = "inst-2"
}

resource "yandex_lb_target_group" "my-tg" {
  name = "my-target-group"

  target {
    subnet_id  ="${data.yandex_compute_instance.data_insti1.network_interface.0.subnet_id}"
    address = "${data.yandex_compute_instance.data_insti1.network_interface.0.ip_address}"
  }

  target {
    subnet_id  = "${data.yandex_compute_instance.data_insti2.network_interface.0.subnet_id}"
    address = "${data.yandex_compute_instance.data_insti2.network_interface.0.ip_address}"
  }
}

resource "yandex_lb_network_load_balancer" "my-lb" {
  name = "my-network-load-balancer"

  listener {
    name = "listener"
    port = 8080
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.my-tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 8080
        path = "/ping"
      }
    }
  }
}
