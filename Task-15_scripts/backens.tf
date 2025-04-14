terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-trupti"
    key    = "wordpress/terraform.tfstate"  # path inside the bucket
    region = "us-west-2"
    encrypt = true
  }
}

