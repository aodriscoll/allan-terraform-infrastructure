resource "aws_s3_bucket" "appdata_bucket" {
  bucket = "infor-eam-dev-appdata-us-east-1"
  acl    = "private"

  tags = {
    Team              = var.team_name
    Product           = var.app_name
    Service           = "${var.app_name}:s3:appdata"
    InforCost         = "DMGRJ-EEN"
    RegFinancialOwner = "mahesh.ganesh@infor.com"
    RegTechnicalOwner = "allan.odriscoll@infor.com"
  }
}

output "appdata_bucket_name" {
  description = "The appdata bucket name."
  value       = aws_s3_bucket.appdata_bucket.bucket
}

output "idm_auth_s3_bucket_name" {
  description = "The idm auth bucket name."
  value       = aws_s3_bucket.appdata_bucket.bucket
}
