terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.47.0"
    }
  }
  backend "s3" {
    bucket = "kieranohara"
    key    = "apps/terraform/kieran-diffusers-main"
    region = "eu-west-2"
  }
}

provider "google" {
  project = var.gcp_project_id
}

variable "gcp_project_id" {}
variable "gcp_instance_image" {
  type    = string
  default = "rocky-linux-8"
}
variable "gcp_instance_machine_type" {
  type    = string
  default = "n1-standard-1"
}
variable "gcp_instance_zone" {
  type    = string
  default = "us-central1-a"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = var.gcp_instance_machine_type
  zone         = var.gcp_instance_zone

  boot_disk {
    initialize_params {
      image = var.gcp_instance_image
    }
  }

  guest_accelerator {
    type  = "nvidia-tesla-t4"
    count = 1
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
}
