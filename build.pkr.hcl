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
    environment_vars = [
      "HOME=/root",
      "ARCH=7.5"
    ]
    inline = [
      "yum install -y sudo",
    ]
  }

  provisioner "shell" {
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
