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
  backend "s3" {
    bucket = "infor-eam-dev-tfstate-us-east-1"
    key    = "eam/global/vpc-infrastructure/vpc-infrastructure.remote.state"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
