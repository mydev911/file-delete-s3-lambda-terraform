# file-delete-s3-lambda-terraform

##### Needs to upload a file to an S3 bucket every day for reporting purposes.  We want to make sure this bucket is emptied out on a weekly basis on Sunday's in order to keep costs down.  Please create an S3 bucket and Lambda function using Terraform and any other services you deem required to complete this task.   This process must be 100% automated and the Lambda function must be created using the latest version of Python.  We also would like the Python script to detect if there are any lingering files left over in the S3 bucket after being emptied and alert members of the DevOps team if any are found.

-------------------------------------------
### varible.tf file  
- Select region 
- Select bucket name
- Select email to get notify
### terraform output file
```
terraform output
```
### terraform output file
```
bucket_id = "my-bucket900021"
cloudwatch_event_rule_description = "Triggers Lambda function to empty S3 bucket every Sunday at midnight"
cloudwatch_event_rule_name = "trigger_empty_s3_bucket"
email = "mydev911@gmail.com"
lambda_exec_role_arn = "arn:aws:iam::784381827836:role/lambda_exec"
lambda_exec_role_name = "lambda_exec"
lambda_function_arn = "arn:aws:lambda:us-east-1:784381827836:function:empty_s3_bucket"
lambda_function_name = "empty_s3_bucket"
lambda_ses_policy_arn = "arn:aws:iam::784381827836:policy/lambda_ses_policy"
lambda_ses_policy_name = "lambda_ses_policy"
```

