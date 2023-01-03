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

variable "gcp_project_id" {}
variable "gcp_source_image_family" {}
variable "gcp_ssh_username" {}
variable "gcp_zone" {}

source "googlecompute" "n1" {
  project_id          = var.gcp_project_id
  source_image_family = var.gcp_source_image_family
  ssh_username        = var.gcp_ssh_username
  zone                = var.gcp_zone
  /* machine_type = "e2-standard-2" */
  on_host_maintenance = "TERMINATE"
  accelerator_type    = "projects/${var.gcp_project_id}/zones/${var.gcp_zone}/acceleratorTypes/nvidia-tesla-t4"
  accelerator_count   = 1
  disk_size = 48
}

build {
  name = "rhel7_vm"

  sources = [
    "source.amazon-ebs.g4dn",
    "source.googlecompute.n1"
  ]

  provisioner "shell" {
    environment_vars = [
      "ARCH=7.5"
    ]
    scripts = [
      "./scripts/utils.sh",
      "./scripts/cuda.sh",
      "./scripts/conda-env.sh",
      "./scripts/xformers.sh",
      "./scripts/source-code.sh"
    ]
  }
}
