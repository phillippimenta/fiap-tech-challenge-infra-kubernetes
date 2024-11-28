terraform {
    required_version = "1.9.6"
  required_providers {
    aws = ">=5.78.0"
    local = ">=2.5.2"
  }
}

provider "aws" {
  region = "us-east-1"
}