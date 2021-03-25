# aws_ecr_repository.eam_ecr_eam_cloud_core:
resource "aws_ecr_repository" "eam_ecr_eam_cloud_core" {
  image_tag_mutability = "MUTABLE"
  name                 = "eam/cloud/core"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "eam_ecr_eam_apache" {
  image_tag_mutability = "MUTABLE"
  name                 = "eam/apache"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "eam_ecr_eam_couchbase" {
  image_tag_mutability = "MUTABLE"
  name                 = "eam/couchbase"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "eam_ecr_eam_microservice" {
  image_tag_mutability = "MUTABLE"
  name                 = "eam/microservice"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "eam_ecr_eam_provision" {
  image_tag_mutability = "MUTABLE"
  name                 = "eam/provision"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "eam_ecr_eam_survey" {
  image_tag_mutability = "MUTABLE"
  name                 = "eam/survey"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}