locals {
  # normalized workspace name
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace

  # base app/project name
  project = "app"

  # standard prefix pattern for all resources
  prefix = "${local.project}-${local.environment}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "mybucket6720"
    key            = "terraform/state/app.tfstate"
    region         = "us-east-1"
    # use_lockfile = true 
    # encrypt        = true
  }

}



# resource "aws_s3_bucket" "my_s3_bucket" {
#   bucket = "mybucket6720"

#   tags = {
#     name = "${local.prefix}-bucket"
#   }

# }

module "vpc-modules" {
  source            = "./vpc-modules"
  vpc_cidr_block    = var.vpc_cidr_block
  az                = var.az
  subnet_cidr_block = var.subnet_cidr_block

}

module "ec2-modules" {
  source        = "./ec2-modules"
  instance_type = var.instance_type
  az            = var.az
  region        = var.region
  vpc_id        = module.vpc-modules.vpc_id
  subnet_id     = module.vpc-modules.subnet_id
}
