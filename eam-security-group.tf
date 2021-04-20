# aws_security_group.public_elb_dbapi_security_group:
resource "aws_security_group" "public_elb_dbapi_security_group" {
  description = "Security group for public elb db api"
  name        = "EamSecurityGroups-PublicELBdbAPISecurityGroup"

  tags = {
    Name              = "EamSecurityGroups-PublicELBdbAPISecurityGroup"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    Team              = "EAM"
  }
  vpc_id = module.vpc.vpc_id
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "52.25.159.202/32",
      ]
      description      = "NATIP"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks = [
        "54.86.51.214/32",
        "54.164.36.164/32",
        "54.85.51.170/32",
        "165.193.94.0/23",
        "54.85.44.47/32",
        "209.214.223.5/32",
        "159.172.175.6/32",
        "209.214.223.1/32",
        "54.88.138.235/32",
        "54.209.221.171/32",
        "54.172.66.209/32",
        "52.3.40.242/32",
      ]
      description      = ""
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
  ]

  timeouts {}
}

# aws_security_group.public_load_balancer_security_group:
resource "aws_security_group" "public_load_balancer_security_group" {
  description = "Public ELB Enable HTTP/HTTPS access"
  name        = "EamSecurityGroups-EamPublicLoadBalancerSecurityGroup"

  tags = {
    Name              = "EamSecurityGroups-EamPublicLoadBalancerSecurityGroup"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    Team              = "EAM"
  }
  vpc_id = module.vpc.vpc_id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 25
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 25
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
  ]

  timeouts {}
}


# aws_security_group.private_load_balancer_security_group:
resource "aws_security_group" "private_load_balancer_security_group" {
  description = "Internal ELB Enable HTTP/HTTPS access"
  name        = "EamSecurityGroups-PrivateLoadBalancerSecurityGroup"
  tags = {
    Name              = "EamSecurityGroups-PrivateLoadBalancerSecurityGroup"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    Team              = "EAM"
  }
  vpc_id = module.vpc.vpc_id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "10.240.0.0/16",
        "10.240.16.0/23",
        "10.201.0.0/16",
        "10.202.0.0/16",
        "10.244.0.0/16",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups = [
        module.vpc.default_security_group_id,
      ]
      self    = false
      to_port = 0
    },
  ]
  timeouts {}
}

output "public_elb_dbapi_security_group_id" {
  description = "The ID of the public elb dbapi security group."
  value       = aws_security_group.public_elb_dbapi_security_group.id
}

output "public_load_balancer_security_group_id" {
  description = "The ID of the public load balancer security group."
  value       = aws_security_group.public_load_balancer_security_group.id
}

output "private_load_balancer_security_group_id" {
  description = "The ID of the private load balancer security group."
  value       = aws_security_group.private_load_balancer_security_group.id
}
