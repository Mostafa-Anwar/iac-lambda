resource "aws_lambda_function" "this" {
  function_name = "lambda-function"
  handler       = "hello.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = "hello.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-function-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.this.function_name}"
}

resource "aws_lambda_permission" "lambda_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = aws_cloudwatch_log_group.lambda_log_group.arn
}
