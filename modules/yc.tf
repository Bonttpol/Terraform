
data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "vm" {
  name = var.name

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/y_vm.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "net1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.vpc-zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = var.vpc-zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}