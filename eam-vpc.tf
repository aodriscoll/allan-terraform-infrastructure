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

output "public_subnet_ids" {
  description = "A list of public subnet IDs."
  value       = module.vpc.public_subnets
}

output "public_subnet_az1" {
  description = "The public subnet ID for AZ1."
  value       = module.vpc.public_subnets[0]
}

output "public_subnet_az2" {
  description = "The public subnet ID for AZ2."
  value       = module.vpc.public_subnets[1]
}

output "public_subnet_az3" {
  description = "The public subnet ID for AZ3."
  value       = module.vpc.public_subnets[2]
}

output "private_subnet_ids" {
  description = "A list of private subnet IDs."
  value       = module.vpc.private_subnets
}

output "private_subnet_az1" {
  description = "The private subnet ID for AZ1."
  value       = module.vpc.private_subnets[0]
}

output "private_subnet_az2" {
  description = "The private subnet ID for AZ2."
  value       = module.vpc.private_subnets[1]
}

output "private_subnet_az3" {
  description = "The private subnet ID for AZ3."
  value       = module.vpc.private_subnets[2]
}

output "default_security_group_id" {
  description = "The name of the default security group."
  value       = module.vpc.default_security_group_id
}

output "availability_zones" {
  description = "A list of availability zones."
  value       = module.vpc.azs
}

output "availability_zone_one" {
  description = "The ID for availability zone one."
  value       = module.vpc.azs[0]
}

output "availability_zone_two" {
  description = "The ID for availability zone two."
  value       = module.vpc.azs[1]
}

output "availability_zone_three" {
  description = "The ID for availability zone three."
  value       = module.vpc.azs[2]
}
