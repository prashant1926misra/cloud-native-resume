provider "aws" {
    region = "ap-south-1"  
}

# IAM role for Lambda execution
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# IAM Policy attachment for Lambda logging and SES access
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Package the Lambda function code
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/../lambda/main.py"
  output_path = "${path.module}/../lambda/lambda_package.zip"
}
