packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "base" {
  image    = "nvidia/cuda:11.7.1-base-rockylinux8"
  commit   = true
  platform = "linux/amd64"
}

build {
  name = "pack"

  sources = [
    "source.docker.base"
  ]

  provisioner "shell" {
    inline = [
      "yum install -y sudo which",
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "HOME=/root",
      "ARCH=7.5"
    ]
    scripts = [
      "./scripts/utils.sh",
      "./scripts/conda-env.sh",
      "./scripts/xformers.sh",
      "./scripts/source-code.sh"
    ]
  }

  post-processor "docker-tag" {
    repository = "kieran-diffusers"
    tags       = ["latest"]
  }
}

variable "region" {}
variable "source_ami" {}
variable "ssh_keypair_name" {}
variable "ssh_username" {}

source "amazon-ebs" "g4dn" {
  ami_name         = "kieran-diffusers"
  instance_type    = "g4dn.xlarge"
  region           = var.region
  source_ami       = var.source_ami
  ssh_username     = var.ssh_username
  ssh_keypair_name = var.ssh_keypair_name
  ssh_agent_auth   = true
  communicator     = "ssh"

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = "48"
    volume_type = "gp2"
  }
}

build {
  name = "ami"

  sources = [
    "source.amazon-ebs.g4dn"
  ]

  provisioner "shell" {
    environment_vars = [
      "ARCH=7.5"
    ]
    scripts = [
      "./scripts/cuda.sh",
      "./scripts/utils.sh",
      "./scripts/conda-env.sh",
      "./scripts/xformers.sh",
      "./scripts/source-code.sh"
    ]
  }
}
