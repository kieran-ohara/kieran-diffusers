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

source "amazon-ebs" "g4dn" {
  ami_name      = "kieran-diffusers"
  instance_type = "g4dn.xlarge"
  region        = "eu-west-2"
  source_ami = "ami-084e8c05825742534"
  ssh_username = "ec2-user"
  ssh_keypair_name = "kieranohara"
  ssh_agent_auth = true
  communicator         = "ssh"

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = "48"
    volume_type= "gp2"
  }
}

build {
  name = "ami"

  sources = [
    "source.amazon-ebs.g4dn"
  ]

  provisioner "shell" {
    environment_vars = [
      "HOME=/home/ec2-user",
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
