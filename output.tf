output "bucket_id" {
value = aws_s3_bucket.my_bucket.id
}

output "lambda_function_arn" {
value = aws_lambda_function.empty_s3_bucket.arn
}

output "email" {
value = aws_ses_email_identity.devops_team_email.email
}

output "lambda_function_name" {
value = aws_lambda_function.empty_s3_bucket.function_name
}

output "lambda_exec_role_arn" {
value = aws_iam_role.lambda_exec.arn
}

output "lambda_exec_role_name" {
value = aws_iam_role.lambda_exec.name
}

output "cloudwatch_event_rule_name" {
value = aws_cloudwatch_event_rule.trigger_empty_s3_bucket.name
}

output "cloudwatch_event_rule_description" {
value = aws_cloudwatch_event_rule.trigger_empty_s3_bucket.description
}

output "lambda_ses_policy_name" {
value = aws_iam_policy.lambda_ses_policy.name
}

output "lambda_ses_policy_arn" {
value = aws_iam_policy.lambda_ses_policy.arn
}