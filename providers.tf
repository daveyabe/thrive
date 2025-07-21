terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
   }
 }
backend "s3" {
    bucket         	   = "tf-state"
    key              	 = "terraform.tfstate"
    region             = "us-east-2"
  }
}

provider "aws" {
  access_key = "AKIAQHAFBDRBJ3GRX6W2"
  secret_key = var.secret_key
  region     = var.aws_region
}
