data "aws_lambda_function" "alpha" {
    function_name = aws_lambda_function.alpha.function_name    
}

data "aws_lambda_function" "beta" {
    function_name = aws_lambda_function.beta.function_name    
}

data "aws_lambda_function" "gamma" {
    function_name = aws_lambda_function.gamma.function_name    
}


locals {
  lambda_functions = [
    data.aws_lambda_function.alpha.function_name,
    data.aws_lambda_function.beta.function_name,
    data.aws_lambda_function.gamma.function_name,
  ]
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  count = length(local.lambda_functions)

  alarm_name          = "lambda-error-alarm-${local.lambda_functions[count.index]}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "SampleCount"
  threshold           = 1
  alarm_description   = "Alarm when Lambda function errors occur for ${local.lambda_functions[count.index]}"
  alarm_actions       = [aws_sns_topic.topic.arn]

  dimensions = {
    FunctionName = local.lambda_functions[count.index]
  }
}



resource "aws_cloudwatch_metric_alarm" "lambda_duration_alarm" {
  count = 3  
  alarm_name          = "lambda-duration-alarm-${local.lambda_functions[count.index]}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "Alarm when Lambda function duration exceeds 500s for ${local.lambda_functions[count.index]}"
  alarm_actions       = [aws_sns_topic.topic.arn]

  dimensions = {
    FunctionName = local.lambda_functions[count.index]
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



resource "aws_cloudwatch_dashboard" "alpha_dashboard" {
  dashboard_name = "Alpha-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type        = "metric"
        x           = 0
        y           = 0
        width       = 6
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Invocations", "FunctionName", local.lambda_functions[0] ],
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Invocations"
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
        x           = 6
        y           = 0
        width       = 8
        height      = 8
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Errors", "FunctionName", local.lambda_functions[0] ]
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Errors"
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
        y           = 0
        width       = 6
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Duration", "FunctionName", local.lambda_functions[0] ]
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Duration"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "beta_dashboard" {
  dashboard_name = "Beta-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type        = "metric"
        x           = 0
        y           = 0
        width       = 6
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Invocations", "FunctionName", local.lambda_functions[1] ],
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Invocations"
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
        x           = 6
        y           = 0
        width       = 8
        height      = 8
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Errors", "FunctionName", local.lambda_functions[1] ]
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Errors"
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
        y           = 0
        width       = 6
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Duration", "FunctionName", local.lambda_functions[1] ]
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Duration"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "gamma_dashboard" {
  dashboard_name = "Gamma-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type        = "metric"
        x           = 0
        y           = 0
        width       = 6
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Invocations", "FunctionName", local.lambda_functions[2] ],
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Invocations"
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
        x           = 6
        y           = 0
        width       = 8
        height      = 8
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Errors", "FunctionName", local.lambda_functions[2] ]
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Errors"
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
        y           = 0
        width       = 6
        height      = 6
        properties = {
          view         = "timeSeries"
          stacked      = false
          metrics      = [
            [ "AWS/Lambda", "Duration", "FunctionName", local.lambda_functions[2] ]
          ]
          region       = "us-east-2"
          liveData     = true
          title        = "Lambda Duration"
        }
      }
    ]
  })
}
