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
  name = "credentials-setup-S3CredentialsManagedPolicy"
  path = "/"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "kms:Decrypt",
          ]
          Effect = "Allow"
          Resource = [
            "*",
          ]
        },
        {
          Action = [
            "s3:ListBucket",
          ]
          Effect   = "Allow"
          Resource = "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-us-east-1"
        },
        {
          Action = [
            "s3:GetObject",
          ]
          Effect = "Allow"
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
      Version = "2012-10-17"
    }
  )
}

# aws_iam_role.eam_access_role:
resource "aws_iam_role" "eam_access_role" {
  force_detach_policies = false
  managed_policy_arns   = []
  max_session_duration  = 3600
  name                  = "EAM_Access_Role"
  path                  = "/"
  tags                  = {}

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "ecs-tasks.amazonaws.com",
              "application-autoscaling.amazonaws.com",
              "es.amazonaws.com",
              "lambda.amazonaws.com",
              "cloudformation.amazonaws.com",
              "states.us-east-1.amazonaws.com",
              "elasticmapreduce.amazonaws.com",
              "firehose.amazonaws.com",
              "apigateway.amazonaws.com",
              "s3.amazonaws.com",
              "redshift.amazonaws.com",
              "ec2.amazonaws.com",
              "autoscaling.amazonaws.com",
              "ecs.amazonaws.com",
              "codebuild.amazonaws.com",
              "states.us-west-2.amazonaws.com",
              "codedeploy.amazonaws.com",
              "states.eu-central-1.amazonaws.com",
            ]
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  inline_policy {
    name = "EAM_Buckets_Policy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "s3:Get*",
              "s3:List*",
              "s3:PutObject",
              "s3:DeleteObject",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::infor-eam-dev-appdata-us-east-1/idm/data/6/oauth-keys",
            ]
          },
          {
            Action = "s3:*"
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::infor-eam-dev-appdata-us-east-1/eam-cognos/*",
              "arn:aws:s3:::infor-eam-dev-appdata-us-west-2/eam-cognos/*",
              "arn:aws:s3:::infor-eam-dev-appdata-eu-central-1/eam-cognos/*",
            ]
          },
        ]
      }
    )
  }

  inline_policy {
    name = "EAM_Extended_Policy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action   = "cloudsearch:*"
            Effect   = "Allow"
            Resource = "arn:aws:cloudsearch:*:*:domain/eam*"
          },
          {
            Action = [
              "acm:List*",
              "acm:Get*",
              "acm:Describe*",
              "apigateway:*",
              "application-autoscaling:*",
              "cloudformation:CreateUploadBucket",
              "cloudformation:Describe*",
              "cloudformation:EstimateTemplateCost",
              "cloudformation:Get*",
              "cloudformation:List*",
              "cloudformation:ValidateTemplate",
              "cloudfront:*",
              "cloudsearch:Describe*",
              "cloudsearch:List*",
              "cloudtrail:DescribeTrails",
              "cloudtrail:GetTrailStatus",
              "cloudtrail:LookupEvents",
              "codebuild:ListBuilds",
              "codebuild:ListConnectedOAuthAccounts",
              "codebuild:ListCuratedEnvironmentImages",
              "codebuild:ListProjects",
              "codebuild:ListRepositories",
              "codebuild:PersistOAuthToken",
              "codecommit:BatchGetRepositories",
              "codecommit:CreateRepository",
              "codecommit:Get*",
              "codecommit:List*",
              "dynamodb:DescribeTable",
              "dynamodb:ListTables",
              "ec2:CopyImage",
              "ec2:CreateImage",
              "ec2:CreateNetworkInterface",
              "ec2:CreateSecurityGroup",
              "ec2:DeleteNetworkInterface",
              "ec2:DetachNetworkInterface",
              "ec2:DeregisterImage",
              "ec2:DescribeNetworkInterfaces",
              "ec2:GetPasswordData",
              "ec2:ImportImage",
              "ec2:ModifyImageAttribute",
              "ec2:ModifyInstanceAttribute",
              "ec2:ModifyNetworkInterfaceAttribute",
              "ec2:ModifyVolumeAttribute",
              "ec2:RegisterImage",
              "ec2:ResetImageAttribute",
              "ec2:RunCommand",
              "ec2messages:AcknowledgeMessage",
              "ec2messages:DeleteMessage",
              "ec2messages:FailMessage",
              "ec2messages:GetEndpoint",
              "ec2messages:GetMessages",
              "ec2messages:SendReply",
              "ecr:BatchCheckLayerAvailability",
              "ecr:BatchGetImage",
              "ecr:CreateRepository",
              "ecr:Describe*",
              "ecr:Get*",
              "ecr:List*",
              "ecs:CreateCluster",
              "ecs:CreateService",
              "ecs:DeleteService",
              "ecs:DeregisterContainerInstance",
              "ecs:RegisterContainerInstance",
              "ecs:DeregisterTaskDefinition",
              "ecs:Describe*",
              "ecs:DiscoverPollEndpoint",
              "ecs:List*",
              "ecs:Poll",
              "ecs:Register*",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:Update*",
              "elasticfilesystem:*",
              "elasticmapreduce:*",
              "es:AddTags",
              "es:Describe*",
              "es:ESHttpGet",
              "es:List*",
              "es:RemoveTags",
              "events:*",
              "execute-api:*",
              "firehose:List*",
              "iam:Get*",
              "iam:List*",
              "iam:UploadServerCertificate",
              "kinesis:ListStreams",
              "kms:*",
              "lambda:CreateEventSourceMapping",
              "lambda:CreateFunction",
              "lambda:DeleteEventSourceMapping",
              "lambda:TagResource",
              "lambda:UntagResource",
              "lambda:Get*",
              "lambda:List*",
              "lambda:ListFunctions",
              "logs:*",
              "redshift:Des*",
              "route53:Get*",
              "route53:List*",
              "sns:List*",
              "sns:Subscribe",
              "sns:Unsubscribe",
              "sqs:ListQueues",
              "states:CreateActivity",
              "states:CreateStateMachine",
              "states:Describe*",
              "states:Get*",
              "states:List*",
              "support:*",
              "trustedadvisor:Describe*",
              "waf:*",
              "waf-regional:*",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ec2:DeleteTags",
            ]
            Condition = {
              StringLike = {
                "aws:RequestTag/Team" = "*"
              }
            }
            Effect   = "Deny"
            Resource = "*"
          },
          {
            Action = [
              "ec2:CreateTags",
            ]
            Condition = {
              Null = {
                "ec2:ResourceTag/Team" = "false"
              }
              StringNotEquals = {
                "ec2:ResourceTag/Team" = "EAM"
              }
            }
            Effect   = "Deny"
            Resource = "*"
          },
          {
            Action = [
              "ec2:CreateTags",
              "ec2:DeleteTags",
              "ec2:AuthorizeSecurityGroupEgress",
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:RevokeSecurityGroupEgress",
              "ec2:RevokeSecurityGroupIngress",
              "ec2:DeleteSecurityGroup",
            ]
            Condition = {
              StringEquals = {
                "ec2:ResourceTag/Team" = "EAM"
              }
            }
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ec2:CreateTags",
            ]
            Condition = {
              Null = {
                "ec2:ResourceTag/Team" = "true"
              }
            }
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action   = "firehose:*"
            Effect   = "Allow"
            Resource = "arn:aws:firehose:*:*:deliverystream/eam*"
          },
          {
            Action   = "kinesis:*"
            Effect   = "Allow"
            Resource = "arn:aws:kinesis:*:*:stream/eam*"
          },
          {
            Action = "lambda:*"
            Effect = "Allow"
            Resource = [
              "arn:aws:lambda:*:*:eam*",
              "arn:aws:lambda:*:*:winTA-eam*",
            ]
          },
          {
            Action   = "logs:*"
            Effect   = "Allow"
            Resource = "arn:aws:logs:*:*:log-group:eam*"
          },
          {
            Action = "redshift:*"
            Effect = "Allow"
            Resource = [
              "arn:aws:redshift:*:*:eam*",
              "arn:aws:redshift:*:*:cluster:eam*",
              "arn:aws:redshift:*:*:securitygroup:eam*",
              "arn:aws:redshift:*:*:securitygroupingress:eam*",
              "arn:aws:redshift:*:*:securitygroupingress:eam*",
              "arn:aws:redshift:*:*:hsmclientcertificate:eam*",
              "arn:aws:redshift:*:*:hsmconfiguration:eam*",
              "arn:aws:redshift:*:*:parametergroup:eam*",
              "arn:aws:redshift:*:*:snapshot:eam*",
              "arn:aws:redshift:*:*:subnetgroup:eam*",
            ]
          },
          {
            Action   = "sqs:*"
            Effect   = "Allow"
            Resource = "arn:aws:sqs:*:*:*eam*"
          },
          {
            Action   = "sns:*"
            Effect   = "Allow"
            Resource = "arn:aws:sns:*:*:*eam*"
          },
          {
            Action = "dynamodb:*"
            Effect = "Allow"
            Resource = [
              "arn:aws:dynamodb:*:*:table/eam*",
            ]
          },
          {
            Action = "cloudformation:*"
            Effect = "Allow"
            Resource = [
              "arn:aws:cloudformation:*:*:stack/eam*",
              "arn:aws:cloudformation:*:*:stack/EC2ContainerService-eam*",
            ]
          },
          {
            Action = "route53:*"
            Effect = "Allow"
            Resource = [
              "arn:aws:route53:::hostedzone/Z2GBNJNES72PDX",
            ]
          },
          {
            Action = "route53:DeleteHostedZone"
            Effect = "Deny"
            Resource = [
              "arn:aws:route53:::hostedzone/Z2GBNJNES72PDX",
            ]
          },
          {
            Action = [
              "codedeploy:BatchGet*",
              "codedeploy:*DeploymentConfig*",
              "codedeploy:List*",
              "codedeploy:Get*",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:codedeploy:*:*:application:*",
              "arn:aws:codedeploy:*:*:deploymentconfig:*",
              "arn:aws:codedeploy:*:*:deploymentgroup:*",
            ]
          },
          {
            Action = "*"
            Effect = "Allow"
            Resource = [
              "arn:aws:codedeploy:*:*:application:eam*",
              "arn:aws:codedeploy:*:*:deploymentgroup:eam*/*",
            ]
          },
          {
            Action = [
              "codecommit:Git*",
              "codecommit:Update*",
              "codecommit:CreateBranch",
              "codecommit:Delete*",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:codecommit:*:*:eam*"
          },
          {
            Action = [
              "codebuild:CreateProject",
              "codebuild:Batch*",
              "codebuild:DeleteProject",
              "codebuild:ListBuildsForProject",
              "codebuild:StartBuild",
              "codebuild:StopBuild",
              "codebuild:UpdateProject",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:codebuild:*:*:project/eam*"
          },
          {
            Action = [
              "swf:List*",
              "swf:Describe*",
              "swf:Count*",
              "swf:Get*",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:swf:*:*:*"
          },
          {
            Action   = "swf:*"
            Effect   = "Allow"
            Resource = "arn:aws:swf:*:*:/domain/eam*"
          },
          {
            Action = [
              "ecs:RunTask",
              "ecs:StartTask",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:ecs:*:*:task-definition/eam*"
          },
          {
            Action = [
              "ecs:UntagResource",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:ecs:*:*:task-definition/eam*",
              "arn:aws:ecs:*:*:cluster/eam*",
              "arn:aws:ecs:*:*:service/eam*",
            ]
          },
          {
            Action = [
              "ecs:StopTask",
              "ecs:PutAttributes",
            ]
            Condition = {
              ArnEquals = {
                "ecs:cluster" = "arn:aws:ecs:*:*:cluster/eam*"
              }
            }
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action   = "ecs:DeleteCluster"
            Effect   = "Allow"
            Resource = "arn:aws:ecs:*:*:cluster/eam*"
          },
          {
            Action   = "ecr:SetRepositoryPolicy"
            Effect   = "Deny"
            Resource = "*"
          },
          {
            Action   = "ecr:*"
            Effect   = "Allow"
            Resource = "arn:aws:ecr:us-east-1:*:repository/eam/*"
          },
          {
            Action = [
              "sns:CreateTopic",
              "sns:Get*",
              "sns:List*",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:sns:us-east-1:*:dynamodb"
          },
          {
            Action = [
              "es:Delete*",
              "es:Update*",
              "es:Create*",
              "es:ESHttpPost",
              "es:ESHttpDelete",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:es:*:*:domain/eam*"
          },
          {
            Action = [
              "states:Delete*",
              "states:Send*",
              "states:StartExecution",
              "states:StopExecution",
              "states:Update*",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:states:*:*:stateMachine:EAM*",
              "arn:aws:states:*:*:stateMachine:eam*",
            ]
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}

output "eam_code_deploy_managed_policy_arn" {
  description = "The ARN of the coded deploy managed policy."
  value       = aws_iam_policy.eam_code_deploy_managed_policy.arn
}

output "eam_code_deploy_managed_policy_name" {
  description = "The name of the coded deploy managed policy."
  value       = aws_iam_policy.eam_code_deploy_managed_policy.name
}

output "eam_credentials_managed_policy_arn" {
  description = "The ARN of the codedeploy managed policy."
  value       = aws_iam_policy.eam_credentials_managed_policy.arn
}

output "eam_credentials_managed_policy_name" {
  description = "The name of the codedeploy managed policy."
  value       = aws_iam_policy.eam_credentials_managed_policy.name
}

output "eam_access_role_arn" {
  description = "The ARN of the eam access role."
  value       = aws_iam_role.eam_access_role.arn
}

output "eam_access_role_name" {
  description = "The name of the eam access role."
  value       = aws_iam_role.eam_access_role.name
}