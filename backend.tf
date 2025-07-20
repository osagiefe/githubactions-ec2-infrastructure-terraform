terraform {
  backend "s3" {
    bucket = "ikeja-q12"
    region = "us-east-1"
    key    = "github/terraform.tfstate"
  }
}