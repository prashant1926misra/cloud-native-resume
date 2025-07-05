variable "region" {
     type        = string
     description = "The AWS region to deploy resources."
     default     = "ap-south-1"
}

variable "lambda_function_name" {
     type        = string
     description = "The name of the Lambda function"
}

variable "sender_email" {
     type        = string
     description = "Sender Email address"
}

variable "recipient_email" {
     type        = string
     description = "Recipient email address"
}
