terraform {
  backend "s3" {
    bucket = "aws-lagos-bucket"
    region = "us-east-1"
    key    = "github/terraform.tfstate"
  }
}