resource "aws_api_gateway_rest_api" "lambda_api_gateway_product_a" {
  name = "lambda_api_gateway_product_a"
}

resource "aws_api_gateway_resource" "resource" {
  path_part     = "example"
  parent_id     = aws_api_gateway_rest_api.lambda_api_gateway_product_a.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.lambda_api_gateway_product_a.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api_gateway_product_a.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id               = aws_api_gateway_rest_api.lambda_api_gateway_product_a.id
  resource_id               = aws_api_gateway_resource.resource.id
  http_method               = aws_api_gateway_method.method.http_method
  integration_http_method   = "GET"
  type                      = "AWS_PROXY"
#   uri                       = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
  uri                       =   aws_lambda_function.product_a.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = aws_api_gateway_rest_api.lambda_api_gateway_product_a.id
  stage_name  = "dev"
}
