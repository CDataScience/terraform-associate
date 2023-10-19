terraform {
  backend "remote" {
    organization = "keisoes"

    workspaces {
      name = "getting-started"
    }
    
  }
  required_providers {
    aws = {
      source = "hashcorp/aws"
      version = "~> 5.0"
    }
  }
}  

locals {
  project_name = "Oscar"
}

