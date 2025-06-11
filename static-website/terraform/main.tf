provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name
  #acl    = "public-read"

  website {
    index_document = "index.html"
  }

  ownership_controls {
     rule {
       object_ownership = "BucketOwnerEnforced"
     }
   }


  tags = {
    Environment = "MVP"
    Project     = "cloud-native-resume"
  }
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.static_site.id
  block_public_acls = false
  ignore_public_acls  = false
  block_public_policy =  false
  restrict_public_buckets = false 


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

