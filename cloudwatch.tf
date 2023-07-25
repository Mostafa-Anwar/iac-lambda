data "aws_lambda_function" "lambda_name" {
    function_name = aws_lambda_function.this.function_name    
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "lambda-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "Alarm when Lambda function errors occur"
  alarm_actions       = [aws_sns_topic.topic.arn]
  dimensions = {
    FunctionName = data.aws_lambda_function.lambda_name.function_name
  }
}

resource "aws_sns_topic" "topic" {
  name = "topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = "m.ossama27@gmail.com"  # Replace this with your desired email address
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration_alarm" {
  alarm_name          = "lambda-duration-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "Alarm when Lambda function duration exceeds 500ms"
  alarm_actions       = [aws_sns_topic.topic.arn]
  dimensions = {
    FunctionName = data.aws_lambda_function.lambda_name.function_name
  }
}


resource "aws_cloudwatch_dashboard" "lambda_dashboard" {
  dashboard_name = "LambdaDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type        = "metric"
        x           = 0
        y           = 0
        width       = 12
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Invocations", "FunctionName", data.aws_lambda_function.lambda_name.function_name ],
            [ "AWS/Lambda", "Errors", "FunctionName", data.aws_lambda_function.lambda_name.function_name ]
          ]
          region       = "us-east-2"
          title        = "Lambda Invocations and Errors"
          yAxis        = {
            left  = {
              min   = 0
            }
            right = {
              min   = 0
            }
          }
        }
      },
      {
        type        = "metric"
        x           = 0
        y           = 6
        width       = 12
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Duration", "FunctionName", data.aws_lambda_function.lambda_name.function_name ]
          ]
          region       = "us-east-1"
          title        = "Lambda Duration"
          yAxis        = {
            left  = {
              min   = 0
            }
            right = {
              min   = 0
            }
          }
        }
      }
    ]
  })
}
