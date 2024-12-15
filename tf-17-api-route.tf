resource "aws_apigatewayv2_route" "tf_api_route" {
  api_id              = aws_apigatewayv2_api.tf_api_gateway.id
  route_key           = "ANY /{proxy+}"

  api_key_required    = false
  authorization_type  = "NONE"
  target              = "integrations/${aws_apigatewayv2_integration.tf_api_integration.id}"

  depends_on = [
    aws_apigatewayv2_api.tf_api_gateway,
    aws_apigatewayv2_integration.tf_api_integration
  ]
}
