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
  #service_account_key_file = "key.json"
  token = var.token
  cloud_id = var.c-id
  folder_id = var.f-id
  zone = var.zone # зона, которая будет использована по умолчанию
}

module "inst1" {
  source = "../modules/"
  name = "inst-1"
  image = "lamp"
  region = "ru-central1-b"
}

module "inst2" {
  source = "../modules/"
  image = "lamp"
  name = "inst-2"
}
