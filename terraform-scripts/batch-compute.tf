resource "aws_ecr_repository" "vi_product_category_repository" {
  name                 = "vi-product-category"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key = var.ecr_kms_key
  }
}

resource "aws_s3_bucket" "vi_product_category_bucket" {
  bucket = "vi-product-categorization-${var.environment}"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = var.s3_kms_key
      }
    }
  }
}

resource "aws_iam_role" "vi_product_category_ecs_instance_role" {
  name = "vi-product_category-ecs-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vi_product_category_ecs_policy_attachment" {
  role       = aws_iam_role.vi_product_category_ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "vi_product_category_ec2_profile" {
  name = "vi-product-category-ec2-profile"
  role = aws_iam_role.vi_product_category_ecs_instance_role.name
}

resource "aws_iam_role" "vi_product_category_batch_service_role" {
  name = "vi-product-category-batch-service-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vi_product_category_batch_policy_attachment" {
  role       = aws_iam_role.vi_product_category_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_security_group" "vi_product_category_security_group" {
  name        = "vi-product-category-security-group"
  description = "Allow communication between MongoDB database"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "No Outbound Restrictions"
  }
}

resource "aws_batch_compute_environment" "vi-product-category-batch-environment" {
  compute_environment_name = "vi-product-category-compute"
  compute_resources {
    instance_role = aws_iam_instance_profile.vi_product_category_ec2_profile.arn
    instance_type = [
        "m5.large"
    ]
    max_vcpus = 2
    min_vcpus = 0
    spot_iam_fleet_role = aws_iam_instance_profile.vi_product_category_ec2_profile.arn
    security_group_ids = [aws_security_group.vi_product_category_security_group.id]
    subnets            = split(",", var.subnet_ids)
    type               = "EC2"
  }
  service_role = aws_iam_role.vi_product_category_batch_service_role.arn
  type = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.vi_product_category_batch_policy_attachment]
  tags = {
    created-by = "terraform"
    component = "vi-product-category"
  }
}

resource "aws_batch_job_queue" "vi-product-category-job-queue" {
  name = "vi-product-category-job-queue"
  state = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.vi-product-category-batch-environment.arn
  ]
  depends_on = [ aws_batch_compute_environment.vi-product-category-batch-environment]
  tags = {
    created-by = "terraform"
    component = "vi-product-category"
    environment = "var.environment"
  }
}

resource "aws_iam_role" "vi_product_category_job_role" {
  name               = "vi-product-category-job-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
      {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          }
      }
    ]
}
EOF
  tags = {
    created-by = "terraform"
    component = "vi-product-category"
    environment = "var.environment"
  }
}

resource "aws_iam_policy" "vi_product_category_job_role_s3_policy" {
  name   = "vi-product-category-job-role-s3-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "s3:Get*",
            "s3:List*",
            "s3:Put*"
        ],
        "Resource": [
          "${aws_s3_bucket.vi_product_category_bucket.arn}",
          "${aws_s3_bucket.vi_product_category_bucket.arn}/*"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vi_product_category_job_policy_attachment" {
  role       = aws_iam_role.vi_product_category_job_role.name
  policy_arn = aws_iam_policy.vi_product_category_job_role_s3_policy.arn
}

resource "aws_batch_job_definition" "vi_product_category_job_definition" {
  name = "vi-product-category-job-definition"
  type = "container"
  parameters = {}
  container_properties = <<CONTAINER_PROPERTIES
{
  "image": "${aws_ecr_repository.vi_product_category_repository.repository_url}",
  "jobRoleArn" :"${aws_iam_role.vi_product_category_job_role.arn}",
  "vcpus": 2,
  "memory": 1024,
  "environment": [ { "name": "PYTHONPATH", "value": "/app/actions" },
                   { "name": "ENV_NAME", "value": "${var.environment}" }
                 ],
  "volumes": [],
  "command": [ "python", "product_categorization.py"]
}
CONTAINER_PROPERTIES
  tags = {
    created-by = "terraform"
    component = "vi-product-category"
    environment = var.environment
  }
}