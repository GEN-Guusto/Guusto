provider "aws" {
  region = var.region
}


# terraform {
#   backend "s3" {
#     bucket = "web-cluster-s3-bucker-oct-05"
#     key    = "eks/state/terraform.tfstate"
#     region = "us-east-1"

#     dynamodb_table = "web-cluster-s3-bucker-oct-05"
#     encrypt        = true
#   }
#}