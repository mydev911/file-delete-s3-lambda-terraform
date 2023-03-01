import boto3
import os
import logging

def handler(event, context):
    logging.basicConfig(level=logging.DEBUG,
                        format='%(levelname)s: %(asctime)s: %(message)s')
    s3 = boto3.client("s3")
    bucket_name = os.environ['BUCKET_NAME']
    objects = s3.list_objects(Bucket=bucket_name)
    if 'Contents' in objects and objects['Contents']:
        for obj in objects['Contents']:
            s3.delete_object(Bucket=bucket_name, Key=obj['Key'])
    else:
        logging.debug(f'Bucket {bucket_name} is already empty')
    objects = s3.list_objects(Bucket=bucket_name)
    if 'Contents' in objects and objects['Contents']:
        logging.error(f'Some files still remain in the bucket {bucket_name} after being emptied. Please check the bucket and remove any remaining files.')
        # send email to DevOps team using Amazon SES
        ses = boto3.client("ses")
        recipient = os.environ['EMAIL']
        subject = f'Lingering files found in S3 bucket {bucket_name}'
        body = f'Please check the bucket and remove any remaining files.'
        message = f'Subject: {subject}\n\n{body}'
        ses.send_email(
            Source='noreply@example.com',
            Destination={
                'ToAddresses': [
                    recipient
                ]
            },
            Message={
                'Subject': {
                    'Data': subject
                },
                'Body': {
                    'Text': {
                        'Data': body
                    }
                }
            }
        )
    else:
        logging.debug(f'Bucket {bucket_name} has been successfully emptied')
