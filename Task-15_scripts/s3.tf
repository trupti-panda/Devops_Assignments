
resource "aws_s3_bucket" "tf_state_s3" {
  bucket = "terraform-state-bucket-trupti"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}

