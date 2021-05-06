#
#   NOTICE
#
#   THIS SOFTWARE IS THE PROPERTY OF AND CONTAINS
#   CONFIDENTIAL INFORMATION OF INFOR AND/OR ITS AFFILIATES
#   OR SUBSIDIARIES AND SHALL NOT BE DISCLOSED WITHOUT PRIOR
#   WRITTEN PERMISSION. LICENSED CUSTOMERS MAY COPY AND
#   ADAPT THIS SOFTWARE FOR THEIR OWN USE IN ACCORDANCE WITH
#   THE TERMS OF THEIR SOFTWARE LICENSE AGREEMENT.
#   ALL OTHER RIGHTS RESERVED.
#
#   (c) COPYRIGHT 2021 INFOR.  ALL RIGHTS RESERVED.
#   THE WORD AND DESIGN MARKS SET FORTH HEREIN ARE
#   TRADEMARKS AND/OR REGISTERED TRADEMARKS OF INFOR
#   AND/OR ITS AFFILIATES AND SUBSIDIARIES. ALL RIGHTS
#   RESERVED.  ALL OTHER TRADEMARKS LISTED HEREIN ARE
#   THE PROPERTY OF THEIR RESPECTIVE OWNERS.
#
#   AUTHOR: Allan O'Driscoll
#   CREATED: 03/19/2021

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

# aws_vpc_peering_connection.eam_development_peering_connection
# terraform import aws_vpc_peering_connection.eam_development_peering_connection pcx-0d71a4cf06ba1a629
# terraform state show aws_vpc_peering_connection.eam_development_peering_connection
resource "aws_vpc_peering_connection" "eam_development_peering_connection" {
    peer_owner_id = "690137975151"
    peer_region   = "us-east-1"
    peer_vpc_id   = "vpc-a2c038c7"
    tags          = {
        "InforCost"         = "DMGRJ-EEN"
        "Name"              = "eam-peering1"
        "Owner"             = "allan.odriscoll@infor.com"
        "Product"           = "eam"
        "RegFinancialOwner" = "mahesh.ganesh@infor.com"
        "RegTechnicalOwner" = "allan.odriscoll@infor.com"
        "Team"              = "EAM"
    }
    tags_all      = {
        "InforCost"         = "DMGRJ-EEN"
        "Name"              = "eam-peering1"
        "Owner"             = "allan.odriscoll@infor.com"
        "Product"           = "eam"
        "RegFinancialOwner" = "mahesh.ganesh@infor.com"
        "RegTechnicalOwner" = "allan.odriscoll@infor.com"
        "Team"              = "EAM"
    }
    vpc_id        = "vpc-0aadff13c7e1f1d92"

    accepter {
        allow_classic_link_to_remote_vpc = false
        allow_remote_vpc_dns_resolution  = false
        allow_vpc_to_remote_classic_link = false
    }

    requester {
        allow_classic_link_to_remote_vpc = false
        allow_remote_vpc_dns_resolution  = false
        allow_vpc_to_remote_classic_link = false
    }
}