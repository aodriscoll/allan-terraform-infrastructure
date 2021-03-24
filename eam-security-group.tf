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





# aws_security_group.eam_app_sg:
resource "aws_security_group" "eam_app_sg" {
  description = "SG for EAM app layer"
  name        = "EAM-app-sg"

  tags = {
    Name              = "EAM-app-sg"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    Team              = "EAM"
  }
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_1" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 21
  protocol    = "tcp"
  to_port     = 21
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_2" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 25
  protocol    = "tcp"
  to_port     = 25
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_3" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 443
  protocol    = "tcp"
  to_port     = 443
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_4" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 53
  protocol    = "tcp"
  to_port     = 53
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_5" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 53
  protocol    = "udp"
  to_port     = 53
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_6" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 8080
  protocol    = "tcp"
  to_port     = 8080
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_7" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 8091
  ipv6_cidr_blocks = [
    "::/0",
  ]
  protocol = "tcp"
  to_port  = 8091
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_8" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 80
  protocol    = "tcp"
  to_port     = 80
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_9" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 9443
  protocol    = "tcp"
  to_port     = 9443
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_10" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_db_sg.id
  to_port                  = 1433
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_11" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 1517
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_db_sg.id
  to_port                  = 1622
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_12" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_db_sg.id
  to_port                  = 6379
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_13" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 9300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.private_load_balancer_security_group.id
  to_port                  = 9300
}

resource "aws_security_group_rule" "eam_app_sg_rule_egress_14" {
  type              = "egress"
  security_group_id = aws_security_group.eam_app_sg.id
  description       = "All Traffic within App security Group"
  from_port         = 0
  protocol          = "-1"
  self              = true
  to_port           = 0
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_1" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.private_load_balancer_security_group.id
  to_port                  = 8080
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_web_sg.id
  to_port                  = 8080
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_3" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "10.240.30.124/32",
  ]
  description = "Rapid 7 Scanning"
  from_port   = 0
  protocol    = "-1"
  to_port     = 0
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_4" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "10.250.0.0/16",
    "10.251.0.0/16",
  ]
  description = "Remote Access"
  from_port   = 22
  protocol    = "tcp"
  to_port     = 22
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_5" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_app_sg.id
  cidr_blocks = [
    "10.250.0.0/16",
    "10.251.0.0/16",
  ]
  description = "Remote Access"
  from_port   = 3389
  protocol    = "tcp"
  to_port     = 3389
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_6" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_app_sg.id
  description       = ""
  from_port         = 0
  protocol          = "-1"
  self              = true
  to_port           = 0
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_7" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 32768
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_load_balancer_security_group.id
  to_port                  = 61000
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_8" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 61614
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_web_sg.id
  to_port                  = 61614
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_9" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 61617
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_web_sg.id
  to_port                  = 61617
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_10" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_db_sg.id
  to_port                  = 6379
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_11" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 9300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.private_load_balancer_security_group.id
  to_port                  = 9300
}

resource "aws_security_group_rule" "eam_app_sg_rule_ingress_12" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_app_sg.id
  description              = ""
  from_port                = 9300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_web_sg.id
  to_port                  = 9300
}

# aws_security_group.eam_web_sg:
resource "aws_security_group" "eam_web_sg" {
  description = "SG for EAM web layer"
  name        = "EAM-web-sg"
  tags = {
    Name              = "EAM-web-sg"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    Team              = "EAM"
  }
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_1" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 2195
  protocol    = "tcp"
  to_port     = 2195
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_2" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 21
  protocol    = "tcp"
  to_port     = 21
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_3" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 25
  protocol    = "tcp"
  to_port     = 25
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_4" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 443
  protocol    = "tcp"
  to_port     = 443
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_5" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 5223
  protocol    = "tcp"
  to_port     = 5223
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_6" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 5228
  protocol    = "tcp"
  to_port     = 5230
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_7" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 53
  protocol    = "tcp"
  to_port     = 53
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_8" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 53
  protocol    = "udp"
  to_port     = 53
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_9" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 6379
  protocol    = "tcp"
  to_port     = 6379
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_10" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_load_balancer_security_group.id
  to_port                  = 80
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_11" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 9443
  protocol    = "tcp"
  to_port     = 9443
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_12" {
  type              = "egress"
  security_group_id = aws_security_group.eam_web_sg.id
  description       = ""
  from_port         = 0
  protocol          = "-1"
  self              = true
  to_port           = 0
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_13" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_db_sg.id
  to_port                  = 1433
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_14" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 1517
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_db_sg.id
  to_port                  = 1622
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_15" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 61614
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 61614
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_16" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 61617
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 61617
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_17" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.private_load_balancer_security_group.id
  to_port                  = 8080
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_18" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 8080
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_19" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 9300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.private_load_balancer_security_group.id
  to_port                  = 9300
}

resource "aws_security_group_rule" "eam_web_sg_rule_egress_20" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 9300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 9300
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_1" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 6379
  protocol    = "tcp"
  to_port     = 6379
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_2" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = "Temporary Email "
  from_port   = 25
  ipv6_cidr_blocks = [
    "::/0",
  ]
  protocol = "tcp"
  to_port  = 25
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_3" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "10.240.30.124/32",
  ]
  description = "Rapid 7 Scanning"
  from_port   = 0
  protocol    = "-1"
  to_port     = 0
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_4" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "10.250.0.0/16",
    "10.251.0.0/16",
  ]
  description = "Remote Access"
  from_port   = 22
  protocol    = "tcp"
  to_port     = 22
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_5" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_web_sg.id
  cidr_blocks = [
    "10.250.0.0/16",
    "10.251.0.0/16",
  ]
  description = "Remote Access"
  from_port   = 3389
  protocol    = "tcp"
  to_port     = 3389
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_6" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_web_sg.id
  description       = ""
  from_port         = 0
  protocol          = "-1"
  self              = true
  to_port           = 0
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_7" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 32768
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_load_balancer_security_group.id
  to_port                  = 61000
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_8" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_web_sg.id
  description       = ""
  from_port         = 4369
  protocol          = "tcp"
  self              = true
  to_port           = 4369
}

resource "aws_security_group_rule" "eam_web_sg_rule_ingress_9" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_web_sg.id
  description              = ""
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_load_balancer_security_group.id
  to_port                  = 80
}


# aws_security_group.eam_db_sg:
resource "aws_security_group" "eam_db_sg" {
  name        = "EAM-db-sg"
  description = "SG for EAM db layer"
  tags = {
    Name              = "EAM-db-sg"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
    Team              = "EAM"
  }
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "eam_db_sg_rule_ingress_1" {
  type              = "ingress"
  security_group_id = aws_security_group.eam_db_sg.id
  description       = ""
  from_port         = 0
  protocol          = "-1"
  self              = true
  to_port           = 0
}

resource "aws_security_group_rule" "eam_db_sg_rule_ingress_2" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_db_sg.id
  description              = ""
  from_port                = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_web_sg.id
  to_port                  = 1433
}

resource "aws_security_group_rule" "eam_db_sg_rule_ingress_3" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_db_sg.id
  description              = ""
  from_port                = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 1433
}

resource "aws_security_group_rule" "eam_db_sg_rule_ingress_4" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_db_sg.id
  description              = ""
  from_port                = 1517
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_web_sg.id
  to_port                  = 1622
}

resource "aws_security_group_rule" "eam_db_sg_rule_ingress_5" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_db_sg.id
  description              = ""
  from_port                = 1517
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 1622
}

resource "aws_security_group_rule" "eam_db_sg_rule_ingress_6" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_db_sg.id
  description              = ""
  from_port                = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 6379
}

resource "aws_security_group_rule" "eam_db_sg_rule_ingress_7" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eam_db_sg.id
  description              = ""
  from_port                = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_elb_dbapi_security_group.id
  to_port                  = 8080
}

resource "aws_security_group_rule" "eam_db_sg_rule_egress_ingress_8" {
  type              = "egress"
  security_group_id = aws_security_group.eam_db_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 21
  protocol    = "tcp"
  to_port     = 21
}

resource "aws_security_group_rule" "eam_db_sg_rule_egress_1" {
  type              = "egress"
  security_group_id = aws_security_group.eam_db_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 25
  protocol    = "tcp"
  to_port     = 25
}

resource "aws_security_group_rule" "eam_db_sg_rule_egress_2" {
  type              = "egress"
  security_group_id = aws_security_group.eam_db_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 443
  protocol    = "tcp"
  to_port     = 443
}

resource "aws_security_group_rule" "eam_db_sg_rule_egress_3" {
  type              = "egress"
  security_group_id = aws_security_group.eam_db_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 53
  protocol    = "tcp"
  to_port     = 53
}

resource "aws_security_group_rule" "eam_db_sg_rule_egress_4" {
  type              = "egress"
  security_group_id = aws_security_group.eam_db_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 53
  protocol    = "udp"
  to_port     = 53
}

resource "aws_security_group_rule" "eam_db_sg_rule_egress_5" {
  type              = "egress"
  security_group_id = aws_security_group.eam_db_sg.id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  description = ""
  from_port   = 80
  protocol    = "tcp"
  to_port     = 80
}

resource "aws_security_group_rule" "eam_db_sg_rule_egress_6" {
  type                     = "egress"
  security_group_id        = aws_security_group.eam_db_sg.id
  description              = ""
  from_port                = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eam_app_sg.id
  to_port                  = 6379
}

output "public_elb_dbapi_security_group_id" {
  description = "The ID of the public elb dbapi security group."
  value       = aws_security_group.public_elb_dbapi_security_group.id
}

output "public_load_balancer_security_group" {
  description = "The ID of the public load balancer security group."
  value       = aws_security_group.public_load_balancer_security_group.id
}

output "private_load_balancer_security_group" {
  description = "The ID of the private load balancer security group."
  value       = aws_security_group.private_load_balancer_security_group.id
}

output "eam_app_security_group" {
  description = "The ID of the eam app security group."
  value       = aws_security_group.eam_app_sg.id
}

output "eam_web_security_group" {
  description = "The ID of the eam web security group."
  value       = aws_security_group.eam_web_sg.id
}

output "eam_db_security_group" {
  description = "The ID of the eam db security group."
  value       = aws_security_group.eam_db_sg.id
}
