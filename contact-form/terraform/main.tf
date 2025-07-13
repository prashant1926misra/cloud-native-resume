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

# Lambda function resource
resource "aws_lambda_function" "lambda_handler" {
  filename         = data.archive_file.example.output_path
  function_name    = "var.lambda_function_name"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  runtime = "python3.12"

  environment {
    variables = {
      RECIPIENT_EMAIL = var.recipient_email
    }
  }
}


#API Gateway Lambda integration 
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route
#https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-routes.html

# Create api gateway 
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "ContactFormAPI"
  protocol_type = "HTTP"
}

# API Gateway Lambda Integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda_handler.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true
}

# API Gateway Route
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "POST /contact"    # HTTP method/resource path   
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}


# Lambda permission for API Gateway
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact_form_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}




