# Define AWS provider and region
provider "aws" {
  region = var.region
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# Create Python script for Lambda function
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "delete_files_function.zip"
}


# Create Lambda function
resource "aws_lambda_function" "empty_s3_bucket" {
  function_name = "empty_s3_bucket"
  handler      = "lambda_function.lambda_handler"
  runtime      = "python3.8"
  filename     = "delete_files_function.zip"
  # source_code_hash = filebase64sha256("lambda_function.zip")
  role         = aws_iam_role.lambda_exec.arn
}

# Create IAM role for Lambda function
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"
 
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

# Attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.lambda_exec.name
}

# Create CloudWatch event to trigger Lambda function
resource "aws_cloudwatch_event_rule" "trigger_empty_s3_bucket" {
  name                = "trigger_empty_s3_bucket"
  description         = "Triggers Lambda function to empty S3 bucket every Sunday at midnight"
  schedule_expression = "cron(0 0 ? * SUN *)"
}

# Add Lambda function as target for CloudWatch event
resource "aws_cloudwatch_event_target" "empty_s3_bucket_target" {
  rule      = aws_cloudwatch_event_rule.trigger_empty_s3_bucket.name
  arn       = aws_lambda_function.empty_s3_bucket.arn
}

# Create SES email
resource "aws_ses_email_identity" "devops_team_email" {
  email = var.email
}

# Create Lambda function IAM policy to allow SES email
resource "aws_iam_policy" "lambda_ses_policy" {
  name = "lambda_ses_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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

# Attach Lambda function IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_ses_policy_attach" {
  policy_arn = aws_iam_policy.lambda_ses_policy.arn
  role       = aws_iam_role.lambda_exec.name
}


# Define Lambda function environment variables
locals {
  lambda_env_vars = {
    BUCKET_NAME = aws_s3_bucket.my_bucket.id
    EMAIL       = var.email
  }
}

