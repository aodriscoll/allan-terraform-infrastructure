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

# aws_iam_policy.eam_code_deploy_managed_policy:
resource "aws_iam_policy" "eam_code_deploy_managed_policy" {
  name = "codedeploy-setup-CodeDeployManagedPolicy"
  path = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action   = "s3:GetBucketLocation"
          Effect   = "Allow"
          Resource = "arn:${data.aws_partition.current.partition}:s3:::*"
          Sid      = "VisualEditor0"
        },
        {
          Action = "s3:List*"
          Effect = "Allow"
          Resource = [
            "arn:${data.aws_partition.current.partition}:s3:::*",
            "arn:${data.aws_partition.current.partition}:s3:::*/*",
          ]
          Sid = "VisualEditor1"
        },
        {
          Action = "s3:Get*"
          Effect = "Allow"
          Resource = [
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-spade-*/*",
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-faro-*/faro-scratch/*",
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-spade-*/spade-revisions/*",
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-spade-*",
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-faro-*",
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-spade-*",
          ]
          Sid = "VisualEditor2"
        },
        {
          Action = "s3:Get*"
          Effect = "Allow"
          Resource = [
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-spade-us-east-1/spade-linkcache/*",
            "arn:${data.aws_partition.current.partition}:s3:::aws-codedeploy-*/*",
            "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-spade-us-east-1",
            "arn:${data.aws_partition.current.partition}:s3:::aws-codedeploy-*",
          ]
          Sid = "VisualEditor3"
        },
      ]
      Version = "2012-10-17"
    }
  )
}

# aws_iam_policy.eam_credentials_managed_policy:
resource "aws_iam_policy" "eam_credentials_managed_policy" {
    name   = "credentials-setup-S3CredentialsManagedPolicy"
    path   = "/"
    policy = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "kms:Decrypt",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "*",
                    ]
                },
                {
                    Action   = [
                        "s3:ListBucket",
                    ]
                    Effect   = "Allow"
                    Resource = "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1"
                },
                {
                    Action   = [
                        "s3:GetObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/trendmicro/id",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/trendmicro/password",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/sumologic/id",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/sumologic/key",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/nessusagent/key",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/domainjoin/kinituser",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/SSHGateway",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/guacamole/duo",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1/trustedrootcertificates/*",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
}

output "eam_code_deploy_managed_policy_arn" {
    description = "The ARN of the coded deploy managed policy."
    value = aws_iam_policy.eam_code_deploy_managed_policy.arn
}

output "eam_code_deploy_managed_policy_name" {
    description = "The name of the coded deploy managed policy."
    value = aws_iam_policy.eam_code_deploy_managed_policy.name
}

output "eam_credentials_managed_policy_arn" {
    description = "The ARN of the coded deploy managed policy."
    value = aws_iam_policy.eam_credentials_managed_policy.arn
}

output "eam_credentials_managed_policy_name" {
    description = "The name of the coded deploy managed policy."
    value = aws_iam_policy.eam_credentials_managed_policy.name
}