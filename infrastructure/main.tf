terraform {
    backend "s3" {
        bucket = "marky-g-tf-state"
        key = "tf-infra/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-state-locking"
        encrypt = true
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

# resource "aws_instance" "example" {
#     ami = "ami-011899242bb902164"
#     instance_type = "t2.micro"
# }

resource "aws_s3_bucket" "terraform_state" {
  bucket = "marky-g-tf-state"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = "marky-g-tf-state"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
}