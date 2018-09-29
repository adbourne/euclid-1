provider "aws" {
  region = "eu-west-1"
}

resource "random_id" "ui_bucket_name" {
  byte_length = 8
  prefix = "euclid-ui-"
}

resource "aws_s3_bucket" "euclid_ui" {
  bucket = "${random_id.ui_bucket_name.dec}"
  acl = "public-read"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_euclid_ui_main",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${random_id.ui_bucket_name.dec}/*",
      "Principal": "*"
    }
  ]
}
EOF
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags {
    project = "euclid"
  }
  force_destroy = true
}

// Output the ui url
output "url" {
  value = "${aws_s3_bucket.euclid_ui.bucket}.s3-website-eu-west-1.amazonaws.com"
}