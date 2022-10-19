terraform {

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  required_version = ">= 0.13"
/*
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "trf"
    region     = "ru-central1"
    key        = ".tfstate"
    access_key = "YCAJEzNB90QYwEzsnQSp87nmK"
    secret_key = "YCM5a6JGoZ9U-w9oTIu5icphgT4mM2sEo2yy-mpy"

    skip_region_validation      = true
    skip_credentials_validation = true
  }*/
}

provider "yandex" {
  zone = var.zone 
}

module "inst1" {
  source = "../modules/"
  name = "inst-1"
  image = "lamp"
  region = "ru-central1-b"
  #version = "= 0.1"
}

module "inst2" {
  source = "../modules/"
  image = "lamp"
  name = "inst-2"
  #version = "= 0.1"
}
