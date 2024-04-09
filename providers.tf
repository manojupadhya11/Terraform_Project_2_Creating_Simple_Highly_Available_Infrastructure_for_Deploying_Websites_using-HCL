terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}
#Here we define the provider and region where we want to create our infrastructure
provider "aws" {
  #configuration options
  region = "ap-south-1"
  
}