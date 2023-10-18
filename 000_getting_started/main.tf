terraform {
  backend "remote" {
    hostname = "value"
    organization = "value"

    workspaces {
      name = "getting-started"
    }
    
  }
  required_providers {
    aws = {
      source = "hashcorp/aws"
      version = "3.58.0"
    }
  }
}  

locals {
  project_name = "Oscar"
}

