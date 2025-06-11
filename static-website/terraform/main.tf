provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
  }

  tags = {
    Environment = "MVP"
    Project     = "cloud-native-resume"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.static_site.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "PublicReadGetObject",
        Effect: "Allow",
        Principal: "*",
        Action: "s3:GetObject",
        Resource: "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}
