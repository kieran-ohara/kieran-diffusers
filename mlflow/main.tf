terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
  backend "s3" {
    bucket = "kieranohara"
    key    = "apps/terraform/kieran-diffusers"
    region = "eu-west-2"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "do-lon1-k8s"
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}


resource "aws_ecrpublic_repository" "ecr-repo-mlflow" {
  provider        = aws.us_east_1
  repository_name = "kieran-diffusers-mlflow"
}

resource "aws_s3_bucket" "bucket" {
  tags = {
    app = "kieran-diffusers"
  }
}

resource "aws_iam_policy" "user-policy" {
  name        = "user-policy"
  path        = "/kieran-diffusers/"
  description = "Policy for kieran-diffusers"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Put*",
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.bucket.arn
      }
    ]
  })

  tags = {
    app = "kieran-diffusers"
  }
}

resource "aws_iam_user" "users" {
  path = "/kieran-diffusers/"
  name = "user"
  tags = {
    app = "kieran-diffusers"
  }
}

resource "aws_iam_access_key" "user-key" {
  user = aws_iam_user.users.name
}

resource "aws_iam_user_policy_attachment" "user-key-attach" {
  user       = aws_iam_user.users.name
  policy_arn = aws_iam_policy.user-policy.arn
}

variable "namespace" {
  default = "kieran-diffusers"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "user-secret" {
  metadata {
    name      = "user-secret"
    namespace = var.namespace
  }
  data = {
    "AWS_ACCESS_KEY_ID"     = aws_iam_access_key.user-key.id
    "AWS_SECRET_ACCESS_KEY" = aws_iam_access_key.user-key.secret
  }
}
