variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "eam-qa7-linux"
}
variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-038f1ca1bd58a5790"
}
variable "key_name" {
  description = "The key name used for the EC2 instance"
  type        = string
  default     = "EAMDevTest"
}
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}
variable "subnet_id" {
  description = "The subnet to deploy the instance into."
  type        = string
  default     = "subnet-04bc33185aa7eca4a"
}
variable "vpc_security_group_ids" {
  description = "The subnet to deploy the instance into."
  type        = list(string)
  default     = ["sg-0bfc40da61cfa321a", "sg-02661ac505f586bfe"]
}

# resource "aws_instance" "eam_bastion" {
#   key_name               = var.key_name
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = var.subnet_id
#   vpc_security_group_ids = var.vpc_security_group_ids
#   iam_instance_profile   = "eam-iam-bastion-profile"

#   tags = {
#     LogicMonitor      = "dev"
#     RegFinancialOwner = "mahesh.ganesh@infor.com"
#     RegTechnicalOwner = "allan.odriscoll@infor.com"
#     InforCost         = "DMGRJ-EEN"
#     Name              = var.instance_name
#     Team              = "EAM"
#     Owner             = "allan.odriscoll@infor.com"
#     Product           = "eam"
#     Service           = "eam:test"
#   }
# }
