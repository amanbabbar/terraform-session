resource "aws_s3_bucket" "b" {
  bucket = "tf-session-bucket-95196478"
  acl    = "public-read"

  versioning {
    enabled = true
  }

  tags {
      Name = "Terraform Session bucket"
  }
}