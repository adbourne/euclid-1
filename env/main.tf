provider "aws" {
  region = "eu-west-1"
}

resource "random_id" "ui_bucket_name" {
  byte_length = 8
  prefix = "euclid-ui-"
}

// Create S3 bucker for user interface
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
    Name = "euclid-ui"
    Project = "euclid"
    Environment = "${var.environment}"
  }
  force_destroy = true
}

// Output the user interface url
output "url" {
  value = "${aws_s3_bucket.euclid_ui.bucket}.s3-website-eu-west-1.amazonaws.com"
}

// Create a DyanmoDB table for features
resource "aws_dynamodb_table" "euclid-features" {
  name = "Features"
  read_capacity = 1
  write_capacity = 1
  hash_key = "FeatureId"
  range_key = "DatasetId"

  attribute {
    name = "FeatureId"
    type = "S"
  }

  attribute {
    name = "DatasetId"
    type = "S"
  }

//  attribute {
//    name = "RemoteFeatureId"
//    type = "S"
//  }

//  attribute {
//    name = "CollectedDateTime"
//    type = "S"
//  }

//  attribute {
//    name = "ReceivedDateTime"
//    type = "S"
//  }

//  attribute {
//    name = "RawFeature"
//    type = "S"
//  }

  tags {
    Name = "euclid-features"
    Project = "euclid"
    Environment = "${var.environment}"
  }
}

resource "random_id" "lambdas_bucket_name" {
  byte_length = 8
  prefix = "euclid-lambdas-"
}

// Create S3 bucket for lambda functions
resource "aws_s3_bucket" "euclid_lambdas" {
  bucket = "${random_id.lambdas_bucket_name.dec}"

  tags {
    Name = "euclid-lambdas"
    Project = "euclid"
    Environment = "${var.environment}"
  }
  force_destroy = true
}

// Create Lambda Function for collecting EA river levels
// N.B - Assumes that Lambda has been uploaded to the specified bucket
resource "aws_lambda_function" "euclid-collect-ea-river-levels" {
  function_name = "CollectEaRiverLevels"

  s3_bucket = "${random_id.lambdas_bucket_name.dec}"
  s3_key    = "collect-ea-river-levels.zip"

  handler = "main"
  runtime = "go1.x"

  role = "${aws_iam_role.euclid-lambda-exec.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "euclid-lambda-exec" {
  name = "euclid-lambda-exec"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_api_gateway_rest_api" "euclid-api-gateway" {
  name        = "EuclidApiGateway"
  description = "Euclid API Gateway - Managed by Terraform"

}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.euclid-api-gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.euclid-api-gateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.euclid-api-gateway.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.euclid-api-gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.euclid-collect-ea-river-levels.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.euclid-api-gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.euclid-api-gateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.euclid-api-gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.euclid-collect-ea-river-levels.invoke_arn}"
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.euclid-api-gateway.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.euclid-collect-ea-river-levels.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.example.invoke_url}"
}