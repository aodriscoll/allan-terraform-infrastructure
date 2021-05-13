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
    managed_policy_arns   = [
        aws_iam_policy.eam_custom_access.arn,
        aws_iam_policy.eam_access_policy.arn,
        aws_iam_policy.eam_modern_policy.arn,
        aws_iam_policy.eam_passrole_policy.arn,
        
    ]
  max_session_duration  = 21600
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
            AWS = [
              "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/EAM_Access_Role",
              "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root",
            ],
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
              "arn:${data.aws_partition.current.partition}:s3:::infor-eam-dev-appdata-us-east-1/idm/data/6/oauth-keys",
            ]
          },
          {
            Action = "s3:*"
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:s3:::infor-eam-dev-appdata-us-east-1/eam-cognos/*",
              "arn:${data.aws_partition.current.partition}:s3:::infor-eam-dev-appdata-us-west-2/eam-cognos/*",
              "arn:${data.aws_partition.current.partition}:s3:::infor-eam-dev-appdata-eu-central-1/eam-cognos/*",
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
            Resource = "arn:${data.aws_partition.current.partition}:cloudsearch:*:*:domain/eam*"
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
              "ec2:Describe*",
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
              "iam:*",
            ]
            Effect   = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/Eam*",
              "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:instance-profile/EC2*",
            ]
          },
          {
            Action = [
              "iam:*",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:iam::690137975151:role/Eam*"
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
            Resource = "arn:${data.aws_partition.current.partition}:firehose:*:*:deliverystream/eam*"
          },
          {
            Action   = "kinesis:*"
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:kinesis:*:*:stream/eam*"
          },
          {
            Action = "lambda:*"
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:lambda:*:*:eam*",
              "arn:${data.aws_partition.current.partition}:lambda:*:*:winTA-eam*",
            ]
          },
          {
            Action   = "logs:*"
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:logs:*:*:log-group:eam*"
          },
          {
            Action = "redshift:*"
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:redshift:*:*:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:cluster:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:securitygroup:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:securitygroupingress:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:securitygroupingress:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:hsmclientcertificate:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:hsmconfiguration:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:parametergroup:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:snapshot:eam*",
              "arn:${data.aws_partition.current.partition}:redshift:*:*:subnetgroup:eam*",
            ]
          },
          {
            Action   = "sqs:*"
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:sqs:*:*:*eam*"
          },
          {
            Action   = "sns:*"
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:sns:*:*:*eam*"
          },
          {
            Action = "dynamodb:*"
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:dynamodb:*:*:table/eam*",
            ]
          },
          {
            Action = "cloudformation:*"
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:cloudformation:*:*:stack/eam*",
              "arn:${data.aws_partition.current.partition}:cloudformation:*:*:stack/EC2ContainerService-eam*",
            ]
          },
          {
            Action = "route53:*"
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:route53:::hostedzone/Z07099601WG7UZHMQST67",
            ]
          },
          {
            Action = "route53:DeleteHostedZone"
            Effect = "Deny"
            Resource = [
              "arn:${data.aws_partition.current.partition}:route53:::hostedzone/Z07099601WG7UZHMQST67",
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
              "arn:${data.aws_partition.current.partition}:codedeploy:*:*:application:*",
              "arn:${data.aws_partition.current.partition}:codedeploy:*:*:deploymentconfig:*",
              "arn:${data.aws_partition.current.partition}:codedeploy:*:*:deploymentgroup:*",
            ]
          },
          {
            Action = "*"
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:codedeploy:*:*:application:eam*",
              "arn:${data.aws_partition.current.partition}:codedeploy:*:*:deploymentgroup:eam*/*",
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
            Resource = "arn:${data.aws_partition.current.partition}:codecommit:*:*:eam*"
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
            Resource = "arn:${data.aws_partition.current.partition}:codebuild:*:*:project/eam*"
          },
          {
            Action = [
              "swf:List*",
              "swf:Describe*",
              "swf:Count*",
              "swf:Get*",
            ]
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:swf:*:*:*"
          },
          {
            Action   = "swf:*"
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:swf:*:*:/domain/eam*"
          },
          {
            Action = [
              "ecs:RunTask",
              "ecs:StartTask",
            ]
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:ecs:*:*:task-definition/eam*"
          },
          {
            Action = [
              "ecs:UntagResource",
            ]
            Effect = "Allow"
            Resource = [
              "arn:${data.aws_partition.current.partition}:ecs:*:*:task-definition/eam*",
              "arn:${data.aws_partition.current.partition}:ecs:*:*:cluster/eam*",
              "arn:${data.aws_partition.current.partition}:ecs:*:*:service/eam*",
            ]
          },
          {
            Action = [
              "ecs:StopTask",
              "ecs:PutAttributes",
            ]
            Condition = {
              ArnEquals = {
                "ecs:cluster" = "arn:${data.aws_partition.current.partition}:ecs:*:*:cluster/eam*"
              }
            }
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action   = "ecs:DeleteCluster"
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:ecs:*:*:cluster/eam*"
          },
          {
            Action   = "ecr:SetRepositoryPolicy"
            Effect   = "Deny"
            Resource = "*"
          },
          {
            Action   = "ecr:*"
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:ecr:${data.aws_region.current.name}:*:repository/eam/*"
          },
          {
            Action = [
              "sns:CreateTopic",
              "sns:Get*",
              "sns:List*",
            ]
            Effect   = "Allow"
            Resource = "arn:${data.aws_partition.current.partition}:sns:${data.aws_region.current.name}:*:dynamodb"
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
            Resource = "arn:${data.aws_partition.current.partition}:es:*:*:domain/eam*"
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
              "arn:${data.aws_partition.current.partition}:states:*:*:stateMachine:EAM*",
              "arn:${data.aws_partition.current.partition}:states:*:*:stateMachine:eam*",
            ]
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}

# aws_iam_policy.eam_access_policy:
resource "aws_iam_policy" "eam_access_policy" {
    name   = "EAM_Access_Policy"
    path   = "/"
    policy = jsonencode(
        {
            Statement = [
                {
                    Action   = "ec2:RunInstances"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:subnet/${module.vpc.public_subnets[0]}",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:subnet/${module.vpc.public_subnets[1]}",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:subnet/${module.vpc.public_subnets[2]}",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:subnet/${module.vpc.private_subnets[0]}",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:subnet/${module.vpc.private_subnets[1]}",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:subnet/${module.vpc.private_subnets[2]}",
                        "arn:${data.aws_partition.current.partition}:ec2:*::image/*",
                        "arn:${data.aws_partition.current.partition}:ec2:*::snapshot/*",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:network-interface/*",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:security-group/*",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:key-pair/*",
                    ]
                    Sid      = "AllowRunInstances"
                },
                {
                    Action   = "ec2:RunInstances"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:instance/*",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*",
                    ]
                    Sid      = "Allowtag"
                },
                {
                    Action    = [
                        "ec2:CreateTags",
                    ]
                    Condition = {
                        StringEquals = {
                            "ec2:CreateAction" = "RunInstances",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:instance/*",
                    ]
                    Sid       = "AllowCreateTagsOnlyLaunching"
                },
                {
                    Action   = [
                        "ec2:AttachNetworkInterface",
                        "ec2:AssociateAddress",
                        "ec2:AllocateAddress",
                        "ec2:ReleaseAddress",
                        "ec2:DisassociateAddress",
                        "ec2:StartInstances",
                        "ec2:Describe*",
                        "ec2:ReportInstanceStatus",
                        "ec2:MonitorInstances",
                        "ec2:CreateVolume",
                        "ec2:ModifyVolume",
                        "ec2:CreateSnapshot",
                        "ec2:DeleteSnapshot",
                        "ec2:CopySnapshot",
                        "ec2:GetConsoleOutput",
                        "cloudwatch:*",
                        "s3:List*",
                        "s3:GetBucketLocation",
                        "s3:GetEncryptionConfiguration",
                        "elasticloadbalancing:*",
                        "ds:*",
                        "elasticache:*",
                        "iam:ListServerCertificates",
                        "autoscaling:Describe*",
                        "sts:DecodeAuthorizationMessage",
                        "elasticache:AddTagsToResource",
                        "elasticache:RemoveTagsFromResource",
                        "autoscaling:CreateOrUpdateTags",
                        "autoscaling:DeleteTags",
                        "autoscaling:DeletePolicy",
                        "tag:Get*",
                        "resource-groups:Get*",
                        "resource-groups:List*",
                        "resource-groups:SearchResources",
                        "servicediscovery:*",
                        "cognito-idp:CreateIdentityPool",
                        "cognito-idp:List*",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
                {
                    Action   = "autoscaling:*"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/eam*",
                        "arn:${data.aws_partition.current.partition}:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/EC2ContainerService-eam*",
                    ]
                },
                {
                    Action   = "autoscaling:DeleteLaunchConfiguration"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/eam*",
                        "arn:${data.aws_partition.current.partition}:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/EC2ContainerService-eam*",
                    ]
                },
                {
                    Action   = "autoscaling:CreateLaunchConfiguration"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/eam*",
                        "arn:${data.aws_partition.current.partition}:autoscaling:*:*:launchConfiguration:*:launchConfigurationName/EC2ContainerService-eam*",
                    ]
                },
                {
                    Action    = [
                        "ec2:StopInstances",
                        "ec2:RebootInstances",
                        "ec2:TerminateInstances",
                        "ec2:AssociateIamInstanceProfile",
                        "ec2:DisassociateIamInstanceProfile",
                        "ec2:GetConsoleScreenshot",
                        "ec2:ReplaceIamInstanceProfileAssociation",
                    ]
                    Condition = {
                        StringLike = {
                            "ec2:ResourceTag/Team" = [
                                "EAM"
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
                {
                    Action   = [
                        "resource-groups:*",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:resource-groups:*:*:group/EAM*",
                    ]
                },
                {
                    Action    = [
                        "ec2:AttachVolume",
                        "ec2:DetachVolume",
                        "ec2:DeleteVolume",
                    ]
                    Condition = {
                        StringEquals = {
                            "ec2:ResourceTag/Team" = "EAM",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:instance/*",
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*",
                    ]
                },
                {
                    Action    = "tag:*"
                    Condition = {
                        StringEquals = {
                            "ec2:ResourceTag/Team" = "EAM",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
                {
                    Action    = "tag:*"
                    Condition = {
                        Null = {
                            "ec2:ResourceTag/Team" = "true",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
            ]
            Version   = "2012-10-17"
        }
    )
}

# aws_iam_policy.eam_modern_policy:
resource "aws_iam_policy" "eam_modern_policy" {
    name   = "EAM_Modern_Policy"
    path   = "/"
    policy = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "ec2:GetLaunchTemplateData",
                        "ec2:DescribeLaunchTemplates",
                        "ec2:DescribeLaunchTemplateVersions",
                        "ec2:CreateLaunchTemplate",
                        "ec2:CreateLaunchTemplateVersion",
                        "ssmmessages:Create*",
                        "ssmmessages:Open*",
                        "ssm:AddTagsToResource",
                        "ssm:Cancel*",
                        "ssm:Create*",
                        "ssm:DeleteActivation",
                        "ssm:DeleteAssociation",
                        "ssm:DeleteInventory",
                        "ssm:DeleteMaintenanceWindow",
                        "ssm:DeletePatchBaseline",
                        "ssm:DeleteResourceDataSync",
                        "ssm:Deregister*",
                        "ssm:Describe*",
                        "ssm:Get*",
                        "ssm:LabelParameterVersion",
                        "ssm:List*",
                        "ssm:PutComplianceItems",
                        "ssm:PutConfigurePackageResult",
                        "ssm:PutInventory",
                        "ssm:Register*",
                        "ssm:RemoveTagsFromResource",
                        "ssm:StartAssociationsOnce",
                        "ssm:StartAutomationExecution",
                        "ssm:StopAutomationExecution",
                        "ssm:Update*",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
                {
                    Action    = [
                        "ec2:DeleteLaunchTemplate",
                        "ec2:ModifyLaunchTemplate",
                        "ec2:DeleteLaunchTemplateVersions",
                    ]
                    Condition = {
                        StringEquals = {
                            "ec2:ResourceTag/Team" = "EAM",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
                {
                    Action   = [
                        "ec2:RunInstances",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ec2:*:*:launch-template/*",
                    ]
                },
                {
                    Action    = [
                        "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                        "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
                    ]
                    Condition = {
                        StringEquals = {
                            "ec2:ResourceTag/Team" = "EAM",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
                {
                    Action    = "iam:PassRole"
                    Condition = {
                        StringLike = {
                            "iam:PassedToService" = "ec2.amazonaws.com*",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
                {
                    Action   = [
                        "ssm:DeleteDocument",
                        "ssm:ModifyDocumentPermission",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ssm:*:*:document/EAM*",
                    ]
                },
                {
                    Action   = [
                        "ssm:Send*",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ssm:*:*:document/*",
                    ]
                },
                {
                    Action    = [
                        "ssm:ResumeSession",
                        "ssm:TerminateSession",
                    ]
                    Condition = {
                        StringLike = {
                            "ssm:resourceTag/aws:ssmmessages:session-id" = [
                                "$${aws:userid}"
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
                {
                    Action    = [
                        "ssm:StartSession",
                        "ssm:TerminateSession",
                        "ssm:ResumeSession",
                        "ssm:Send*",
                    ]
                    Condition = {
                        StringLike = {
                            "ssm:ResourceTag/Team" = [
                                "EAM"
                            ]
                        }
                    }
                    Effect    = "Allow"
                    Resource  = "*"
                },
                {
                    Action   = [
                        "ssm:StartSession",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ssm:*:*:document/AWS-StartPortForwardingSession",
                    ]
                },
                {
                    Action   = [
                        "ssm:PutParameter",
                        "ssm:DeleteParameter*",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/EAM*",
                        "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/eam*",
                    ]
                },
                {
                    Action   = [
                        "s3:*",
                        "ssm:Send*",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-eam",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-eam*/",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-eam*/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-eam/*",
                    ]
                },
                {
                    Action      = [
                        "s3:*",
                        "ssm:Send*",
                    ]
                    Effect      = "Allow"
                    NotResource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev*",
                    ]
                },
                {
                    Action   = [
                        "s3:PutBucketAcl",
                        "s3:PutBucketPolicy",
                        "s3:DeleteBucketPolicy",
                    ]
                    Effect   = "Deny"
                    Resource = "*"
                },
                {
                    Action   = "s3:Get*"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-appdata-*/eam/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-salt-pillar-*/eam/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-repositories-*/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-credentials-*/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-faro-*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-spade-*",
                    ]
                },
                {
                    Action   = [
                        "s3:Put*",
                        "ssm:Send*",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-appdata-*/eam/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-faro-*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-spade-*",
                    ]
                },
                {
                    Action   = "s3:Delete*"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-appdata-*/eam/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-faro-*/*tmp/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-spade-*/*tmp/*",
                    ]
                },
                {
                    Action   = "s3:DeleteObject*"
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-salt-pillar-*/eam/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-repositories-*/*",
                    ]
                },
                {
                    Action   = [
                        "s3:PutObject*",
                        "ssm:Send*",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-salt-pillar-*/eam/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-dev-repositories-*/*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-faro-*/tmp*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-devops-core-faro-*/faro-scratch*",
                        "arn:${data.aws_partition.current.partition}:s3:::infor-auto-mingle-us-east-1/mingle/gnair/ifsinteg/SPProperties/m12test/*",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
}

# aws_iam_policy.eam_custom_access:
resource "aws_iam_policy" "eam_custom_access" {
    name   = "EAM_Custom_Access"
    path   = "/"
    policy = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "sqs:*",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:eam*",
                    ]
                },
                {
                    Action   = [
                        "mq:*",
                        "ec2:CreateNetworkInterface",
                        "ec2:DeleteNetworkInterface",
                        "ec2:DetachNetworkInterface,",
                        "ec2:DescribeInternetGateways,",
                        "ec2:DescribeNetworkInterfaces,",
                        "ec2:DescribeRouteTables,",
                        "ec2:DescribeSecurityGroups,",
                        "ec2:DescribeSubnets,",
                        "ec2:DescribeVpcs",
                        "ec2:DeleteNetworkInterfacePermission",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "*",
                    ]
                },
                {
                    Action    = [
                        "ec2:CreateNetworkInterfacePermission",
                        "ec2:DescribeNetworkInterfacePermissions",
                    ]
                    Condition = {
                        StringEquals = {
                            "ec2:AuthorizedService" = "mq.amazonaws.com",
                        }
                    }
                    Effect    = "Allow"
                    Resource  = [
                        "*",
                    ]
                },
                {
                    Action   = [
                        "s3:PutObject",
                        "s3:ListObject",
                        "s3:GetObject",
                        "s3:DeleteObject",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:s3:::devops-dev-appclone-*/eam/*",
                    ]
                },
                {
                    Action   = [
                        "lambda:InvokeFunction",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:ionce-provisioning-api-ionce-app-integ-qac",
                    ]
                },
                {
                    Action   = [
                        "lambda:InvokeFunction",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:ionce-provision-oauth-token-ionce-app-integ-qac",
                    ]
                },
                {
                    Action   = [
                        "backup:*",
                        "backup-storage:*",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                },
                {
                    Action   = [
                        "ecs:UntagResource",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:${data.aws_partition.current.partition}:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/eam*",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
}

# aws_iam_policy.eam_passrole_policy:
resource "aws_iam_policy" "eam_passrole_policy" {
    name   = "EAM_PassRole_Policy"
    path   = "/"
    policy = jsonencode(
        {
            Statement = [
                {
                    Action   = [       
                        "iam:PassRole",
                    ]
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EAM_Access_Role",
                        "arn:aws:iam::*:role/ecsInstanceRole",
                        "arn:aws:iam::*:role/ecsServiceRole",
                        "arn:aws:iam::*:role/aws-service-role/*",
                        "arn:aws:iam::*:role/*CodeDeployServiceRole*",
                        "arn:aws:iam::*:role/eam*",
                    ]
                },
            ]
            Version   = "2012-10-17"
        }
    )
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

output "eam_ops_role_arn" {
  description = "The ARN of the eam access role."
  value       = aws_iam_role.eam_access_role.arn
}

output "eam_ops_role_name" {
  description = "The name of the eam access role."
  value       = aws_iam_role.eam_access_role.name
}

output "network_ops_role_arn" {
  description = "The ARN of the network operations role."
  value       = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:user/aodriscoll"
}