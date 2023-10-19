terraform {
  backend "remote" {
    #hostname = "value"
    organization = "keisoes"

    workspaces {
      name = "provisioners"
    }
    
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}  


provider "aws" {
  profile = "default"
  region = "us-east-1"
  alias   = "us"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  alias   = "eu"
}
