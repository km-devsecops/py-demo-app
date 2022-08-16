variable region {
  default = "us-west-2"
}

variable environment {
  default = "dev"
}
variable s3_kms_key {}
variable ecr_kms_key {}

variable vpc_id {
  default = ""
}

variable subnet_ids {}
variable tags {
  type = map
  default = {
    "owner" = "devops@cybersecurityworks.com"
    "terraform-spawned" = "true"
  }
}

