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

  resource "aws_iam_policy" "lambda_policy" {
    name        = "lambda-function-policy"
    description = "IAM policy for Lambda function to write logs to CloudWatch"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "logs:CreateLogGroup"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.alpha.function_name}:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:CreateLogStream"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.alpha.function_name}:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:PutLogEvents"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}-log-group:/aws/lambda/${aws_lambda_function.alpha.function_name}:*:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:CreateLogGroup"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.beta.function_name}:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:CreateLogStream"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.beta.function_name}:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:PutLogEvents"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}-log-group:/aws/lambda/${aws_lambda_function.beta.function_name}:*:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:CreateLogGroup"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.gamma.function_name}:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:CreateLogStream"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.gamma.function_name}:*"
      },
      {
        Effect    = "Allow"
        Action    = "logs:PutLogEvents"
        Resource  = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}-log-group:/aws/lambda/${aws_lambda_function.gamma.function_name}:*:*"
      },
    ]
  })
}

  resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    policy_arn = aws_iam_policy.lambda_policy.arn
    role       = aws_iam_role.lambda_role.name
  }
  
resource "aws_cloudwatch_log_group" "alphalambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.alpha.function_name}"
}

resource "aws_cloudwatch_log_group" "betalambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.beta.function_name}"
}

resource "aws_cloudwatch_log_group" "gammalambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.gamma.function_name}"
}


resource "aws_lambda_permission" "alphalambda_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alpha.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = aws_cloudwatch_log_group.alphalambda_log_group.arn
}

resource "aws_lambda_permission" "betalambda_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.beta.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = aws_cloudwatch_log_group.betalambda_log_group.arn
}

resource "aws_lambda_permission" "gammalambda_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gamma.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = aws_cloudwatch_log_group.gammalambda_log_group.arn
}

resource "aws_lambda_function" "alpha" {
  function_name = "alpha"
  handler       = "hello.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = "hello.zip"
}

resource "aws_lambda_function" "beta" {
  function_name = "beta"
  handler       = "hello.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = "hello.zip"
}


resource "aws_lambda_function" "gamma" {
  function_name = "gamma"
  handler       = "notify.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = "dash.zip"
}

