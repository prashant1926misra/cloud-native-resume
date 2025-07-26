
/*
Documentation:
 https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
 https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item
 https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_lambda-access-dynamodb.html

*/

provider "aws" {
    region = "ap-south-1"  
}

resource "aws_dynamodb_table" "visitor_count_table" {
  name           = "visitor_count_table"
  billing_mode   = "PAY_PER_REQUEST"   # Controls how you are charged for read and write throughput. Default - Provisioned 
  hash_key       = "id"                # Parition key eg user1 user2... must be unique 

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "visitor_count_table"
    Environment = "DEV"
  }
}

resource "aws_dynamodb_table_item" "initial_item" {
  table_name = aws_dynamodb_table.visitor_count_table.name
  hash_key   = aws_dynamodb_table.visitor_count_table.hash_key

  item = <<ITEM
{
  "id": {"S": "visits"},
  "count": {"N": "0"},
}
ITEM
}


# Define an IAM role that allows Lambda to access resources in AWS account
resource "aws_iam_role" "lambda_exec_role" {
    name               = "lambda_execution_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# Fetch AWS account Id dynamically
data "aws_caller_identity" "current" {}


# IAM Policy attachement for Lambda access to DynamoDB
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "lambda-dynamodb-access-policy"
  description = "Policy that allows Lambda functions to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = [
          "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/visitor_count_table",
          "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/visitor_count_table/index/*"
        ]
      }
    ]
  })
}

# Attach a policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_dynamorole" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}


# Package the Lambda function code
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/../lambda/main.py"
  output_path = "${path.module}/lambda/lambda_package.zip"
}

# Lambda function
resource "aws_lambda_function" "lambda_handler" {
  filename         = data.archive_file.lambda_package.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  runtime = "python3.12"

}
