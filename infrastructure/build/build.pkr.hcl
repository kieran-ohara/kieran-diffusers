packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "gcp_project_id" {}
variable "gcp_ssh_username" {}
variable "gcp_zone" {
  type    = string
  default = "us-central1-a"
}
variable "gcp_machine_type" {
  type    = string
  default = "e2-standard-4"
}
variable "gcp_build_image" {
  type    = string
  default = "rocky-linux-8"
}

source "googlecompute" "rockylinux8" {
  project_id          = var.gcp_project_id
  source_image_family = var.gcp_build_image
  image_name = "kieran-diffusers-{{timestamp}}"
  ssh_username        = var.gcp_ssh_username
  zone                = var.gcp_zone
  machine_type        = var.gcp_machine_type
  disk_size           = 48
}

build {
  name = "sd"

  sources = [
    "source.googlecompute.rockylinux8",
  ]

  provisioner "ansible" {
    host_alias    = source.name
    playbook_file = "./ansible/ansible-playbook.yml"
    use_proxy     = false
    only          = ["googlecompute.rockylinux8"]
  }
}
