output "api_endpoint" {
  description = "Base URL for the deployed API Gateway HTTP API"
  value       = aws_apigatewayv2_api.api_gateway.api_endpoint
}
