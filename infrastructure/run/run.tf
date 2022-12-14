terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
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

resource "aws_s3_bucket" "bucket" {
  bucket = "kieran-diffusers-dvc"
  tags = {
    app = "kieran-diffusers"
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucketpolicy.json
}

data "aws_iam_policy_document" "bucketpolicy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "user-policy" {
  name        = "dvc-policy"
  path        = "/kieran-diffusers/"
  description = "Policy for kieran-diffusers"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.bucket.arn}"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      },
    ]
  })
  tags = {
    app = "kieran-diffusers"
  }
}

resource "aws_iam_user" "user" {
  path = "/kieran-diffusers/"
  name = "kieran-diffuser-user"
  tags = {
    app = "kieran-diffusers"
  }
}

resource "aws_iam_user_policy_attachment" "user-policy-attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.user-policy.arn
}

resource "aws_iam_access_key" "user-key" {
  user = aws_iam_user.user.name
}

provider "google" {
  project = var.gcp_project_id
}

variable "gcp_project_id" {}

variable "gcp_machine_image" {
  type    = string
  default = "rocky-linux-8"
}
variable "gcp_machine_type" {
  type    = string
  default = "n1-standard-4"
}
variable "gcp_gpu_count" {
  type = number
  default = 0
}
variable "gcp_zone" {
  type    = string
  default = "us-central1-a"
}

variable "sd_user_public_key" {}
variable "sd_user_password" {}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.gcp_machine_image
      # 48 for base image, + 20 for user
      size = 68
    }
  }

  guest_accelerator {
    type  = "nvidia-tesla-t4"
    count = var.gcp_gpu_count
  }
  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  allow_stopping_for_update = true

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    user-data = templatefile(
      "cloud-config.yml",
      {
        "sd_user_public_key" = var.sd_user_public_key
        "sd_user_password" = var.sd_user_password
        "aws_access_key_id"  = aws_iam_access_key.user-key.id
        "aws_secret_access_key" = aws_iam_access_key.user-key.secret
      }
    )
  }
}

output "ipaddress" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
