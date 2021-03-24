variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}
variable "team_name" {
  default     = "EAM"
  description = "Application team name.gmaingmain"
}
variable "app_name" {
  default     = "eam"
  description = "Application short name."
}

variable "account_name" {
  default     = "eam-dev"
  description = "The name of the AWS account."
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = "${var.account_name}-vpc"
  cidr                 = "10.42.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.42.1.0/24", "10.42.2.0/24", "10.42.3.0/24"]
  private_subnets      = ["10.42.4.0/24", "10.42.5.0/24", "10.42.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Team              = var.team_name
    Product           = var.app_name
    Service           = "${var.app_name}:vpc"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
  }

  public_subnet_tags = {
    Team              = var.team_name
    Product           = var.app_name
    Service           = "${var.app_name}:public:subnet"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
  }

  private_subnet_tags = {
    Team              = var.team_name
    Product           = var.app_name
    Service           = "${var.app_name}:private:subnet"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
  }
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}
