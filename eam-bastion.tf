variable "linux_instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "eam-utility-linux"
}
variable "windows_instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "eam-utility-windows"
}
variable "linux_ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-038f1ca1bd58a5790"
}
variable "windows_ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0dbd513403bec90c7"
}
variable "key_name" {
  description = "The key name used for the EC2 instance"
  type        = string
  default     = "EAMDevTest"
}
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.large"
}
variable "subnet_id" {
  description = "The subnet to deploy the instance into."
  type        = string
  default     = "subnet-04bc33185aa7eca4a"
}
variable "vpc_security_group_ids" {
  description = "The subnet to deploy the instance into."
  type        = list(string)
  default     = ["sg-035d38f5aa0f6e3b1", "sg-0bfc40da61cfa321a", "sg-0591370abb533143b"]
}

resource "aws_instance" "eam_linux_bastion" {
  key_name               = var.key_name
  ami                    = var.linux_ami
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = "eam-iam-bastion-profile"

  tags = {
    LogicMonitor      = "dev"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    InforCost         = "DMGRJ-EEN"
    Name              = var.linux_instance_name
    Team              = "EAM"
    Owner             = "allan.odriscoll@infor.com"
    Product           = "eam"
    Service           = "eam:utility"
  }
}

resource "aws_instance" "eam_windows_bastion" {
  key_name               = var.key_name
  ami                    = var.windows_ami
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = "eam-iam-bastion-profile"

  tags = {
    LogicMonitor      = "dev"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    InforCost         = "DMGRJ-EEN"
    Name              = var.windows_instance_name
    Team              = "EAM"
    Owner             = "allan.odriscoll@infor.com"
    Product           = "eam"
    Service           = "eam:utility"
  }
}
