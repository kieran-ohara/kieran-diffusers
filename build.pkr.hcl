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

variable "aws_ssh_keypair_name" {}

variable "aws_instance_type" {
  type    = string
  default = "g4dn.xlarge"
}
variable "aws_region" {
  type    = string
  default = "eu-west-2"
}
variable "aws_source_ami" {
  type    = string
  default = "ami-036e229aa5fa198ba"
}
variable "aws_ssh_username" {
  type    = string
  default = "centos"
}

source "amazon-ebs" "sd" {
  ami_name         = "kieran-diffusers"
  instance_type    = var.aws_instance_type
  region           = var.aws_region
  source_ami       = var.aws_source_ami
  ssh_username     = var.aws_ssh_username
  ssh_keypair_name = var.aws_ssh_keypair_name
  ssh_agent_auth   = true
  communicator     = "ssh"

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = "60"
    volume_type = "gp2"
  }
}

variable "gcp_project_id" {}
variable "gcp_ssh_username" {}

variable "gcp_source_image_family" {
  type    = string
  default = "centos-7"
}
variable "gcp_zone" {
  type    = string
  default = "asia-east1-a"
}
variable "gcp_machine_type" {
  type    = string
  default = "n1-standard-1"
}

source "googlecompute" "sd" {
  project_id          = var.gcp_project_id
  source_image_family = var.gcp_source_image_family
  ssh_username        = var.gcp_ssh_username
  zone                = var.gcp_zone
  machine_type        = var.gcp_machine_type
  on_host_maintenance = "TERMINATE"
  accelerator_type    = "projects/${var.gcp_project_id}/zones/${var.gcp_zone}/acceleratorTypes/nvidia-tesla-t4"
  accelerator_count   = 1
  disk_size           = 60
}

build {
  name = "centos7"

  sources = [
    "source.amazon-ebs.sd",
    "source.googlecompute.sd"
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
