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

source "amazon-ebs" "centos7" {
  ami_name         = "kieran-diffusers"
  instance_type    = var.aws_instance_type
  region           = var.aws_region
  source_ami       = var.aws_source_ami
  ssh_username     = var.aws_ssh_username
  ssh_keypair_name = var.aws_ssh_keypair_name
  ssh_agent_auth   = true
  communicator     = "ssh"

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = "48"
    volume_type = "gp2"
  }
}

variable "gcp_project_id" {}
variable "gcp_ssh_username" {}
variable "gcp_zone" {
  type    = string
  default = "asia-east1-a"
}
variable "gcp_machine_type" {
  type    = string
  default = "n1-standard-1"
}

source "googlecompute" "rockylinux8" {
  project_id          = var.gcp_project_id
  source_image_family = "rocky-linux-8"
  ssh_username        = var.gcp_ssh_username
  zone                = var.gcp_zone
  machine_type        = var.gcp_machine_type
  on_host_maintenance = "TERMINATE"
  accelerator_type    = "projects/${var.gcp_project_id}/zones/${var.gcp_zone}/acceleratorTypes/nvidia-tesla-t4"
  accelerator_count   = 1
  disk_size           = 48
}

source "googlecompute" "centos7" {
  project_id          = var.gcp_project_id
  source_image_family = "centos-7"
  ssh_username        = var.gcp_ssh_username
  zone                = var.gcp_zone
  machine_type        = var.gcp_machine_type
  on_host_maintenance = "TERMINATE"
  accelerator_type    = "projects/${var.gcp_project_id}/zones/${var.gcp_zone}/acceleratorTypes/nvidia-tesla-t4"
  accelerator_count   = 1
  disk_size           = 48
}

build {
  name = "sd"

  sources = [
    "source.amazon-ebs.centos7",
    "source.googlecompute.rockylinux8",
    "source.googlecompute.centos7"
  ]

  provisioner "ansible" {
    host_alias    = source.name
    playbook_file = "./ansible/ansible-playbook.yml"
    use_proxy     = false
    only          = ["googlecompute.rockylinux8"]
  }

  provisioner "shell" {
    scripts = [
      "./scripts/utils.sh",
      "./scripts/cuda.sh",
      "./scripts/prep-conda.sh",
    ]
    only = [
      "amazon-ebs.centos7",
      "googlecompute.centos7"
    ]
  }

  provisioner "shell" {
    scripts = [
      "./scripts/alacritty.sh",
      "./scripts/conda-env.sh",
      "./scripts/xformers.sh",
      "./scripts/source-code.sh"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "ARCH=7.5"
    ]
    scripts = [
      "./scripts/build-xformers-centos7.sh"
    ]
    only = [
      "amazon-ebs.centos7",
      "googlecompute.centos7"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "ARCH=7.5"
    ]
    scripts = [
      "./scripts/build-xformers.sh"
    ]
    only = ["googlecompute.rockylinux8"]
  }
}
