# aws_iam_role.bastion_role:
resource "aws_iam_role" "bastion_role" {
  managed_policy_arns = []
  name                = "eam-iam-bastion"
  tags = {
    "Team"    = "EAM"
    "Product" = "eam"
  }

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2008-10-17"
    }
  )

  inline_policy {
    name = "ASGAccessPolicy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "autoscaling:DescribeAutoScalingInstances",
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeLifecycle*",
            ]
            Effect   = "Allow"
            Resource = "*"
            Sid      = "ASGAccessPolicy"
          },
          {
            Action = [
              "autoscaling:CompleteLifecycleAction",
              "autoscaling:RecordLifecycleActionHeartbeat",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:autoscaling:us-east-1:690137975151:autoScalingGroup:*:autoScalingGroupName/eam*",
            ]
            Sid = "ASGLifeCycleAccessPolicy"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }

  inline_policy {
    name = "SessionManagerPolicy"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "ssmmessages:CreateControlChannel",
              "ssmmessages:CreateDataChannel",
              "ssmmessages:OpenControlChannel",
              "ssmmessages:OpenDataChannel",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "s3:GetEncryptionConfiguration",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ssm:DescribeAssociation",
              "ssm:GetDeployablePatchSnapshotForInstance",
              "ssm:GetDocument",
              "ssm:DescribeDocument",
              "ssm:GetManifest",
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:ListAssociations",
              "ssm:ListInstanceAssociations",
              "ssm:PutInventory",
              "ssm:PutComplianceItems",
              "ssm:PutConfigurePackageResult",
              "ssm:UpdateAssociationStatus",
              "ssm:UpdateInstanceAssociationStatus",
              "ssm:UpdateInstanceInformation",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ec2messages:AcknowledgeMessage",
              "ec2messages:DeleteMessage",
              "ec2messages:FailMessage",
              "ec2messages:GetEndpoint",
              "ec2messages:GetMessages",
              "ec2messages:SendReply",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ssm:TerminateSession",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:ssm:us-east-1:690137975151:session/*"
          },
          {
            Action = [
              "ssm:StartSession",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:ec2:us-east-1:690137975151:instance/*"
            Condition = {
              BoolIfExists = {
                "ssm:SessionDocumentAccessCheck" = "true",
              },
              StringEqualsIgnoreCase = {
                "aws:ResourceTag/Team" = "eam",
              }
            }
          },
          {
            Action = [
              "ssm:StartSession",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:ssm:us-east-1:690137975151:document/SSM-SessionManagerRunShell"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }

  inline_policy {
    name = "ecs-service"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "autoscaling:Describe*",
              "cloudwatch:GetMetricStatistics",
              "cloudwatch:ListMetrics",
              "ec2:DescribeInstances",
              "ec2:DescribeTags",
              "ecr:BatchCheckLayerAvailability",
              "ecr:BatchGetImage",
              "ecr:GetAuthorizationToken",
              "ecr:GetDownloadUrlForLayer",
              "ecs:DiscoverPollEndpoint",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ecs:*",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:ecs:us-east-1:690137975151:cluster/eam-*",
              "arn:aws:ecs:us-east-1:690137975151:container-instance/eam-*",
            ]
          },
          {
            Action = [
              "ecs:DescribeContainerInstances",
              "ecs:DescribeTasks",
              "ecs:ListTasks",
              "ecs:Poll",
              "ecs:RunTask",
              "ecs:StartTask",
              "ecs:StartTelemetrySession",
              "ecs:StopTask",
              "ecs:UpdateContainerAgent",
            ]
            Effect   = "Allow"
            Resource = "*"
            Condition = {
              ArnEquals = {
                "ecs:cluster" = "arn:aws:ecs:us-east-1:690137975151:cluster/eam-*"
              }
            }

          },
          {
            Action = [
              "ecs:RunTask",
              "ecs:StartTask",
              "ecs:Submit*",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:ecs:us-east-1:690137975151:task-definition/eam-*",
            ]
          },
          {
            Action = [
              "s3:ListMultipartUploadParts",
              "s3:GetObject*",
              "s3:PutObject*",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:s3:::infor-eam-dev-appdata-us-east-1/eam/*"
          },
          {
            Action = [
              "s3:PutObjectACL",
            ]
            Effect   = "Deny"
            Resource = "arn:aws:s3:::infor-eam-dev-appdata-us-east-1/eam/*"
          },
          {
            Action = [
              "s3:Get*",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:s3:::infor-filetransfer-us-east-1*"
          },
          {
            Action = [
              "cloudwatch:PutMetricData",
            ]
            Effect   = "Allow"
            Resource = "*"
            Condition = {
              StringLike = {
                "cloudwatch:namespace" = [
                  "AWS/ECS",
                  "AWS/EC2",
                  "CWAgent",
                  "eam*",
                ]
              }
            }
          },
          {
            Action = [
              "sns:Publish",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:sns:us-east-1:690137975151:eam-*",
            ]
          },
          {
            Action = [
              "logs:PutLogEvents",
              "logs:CreateLogStream",
              "logs:CreateLogGroup",
              "logs:DescribeLogStreams",
              "logs:DescribeLogGroups",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:logs:us-east-1:690137975151:log-group:/ecs/eam*",
              "arn:aws:logs:us-east-1:690137975151:log-group:/eam*",
            ]
          },
          {
            Action = [
              "ssm:GetParameter",
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*",
            ]
          },
        ]
      }
    )
  }
}


resource "aws_iam_instance_profile" "bastion_profile" {
  name = "eam-iam-bastion-profile"
  role = aws_iam_role.bastion_role.name
}