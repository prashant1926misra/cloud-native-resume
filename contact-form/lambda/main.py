import json
import os
import logging
import boto3
from botocore.exceptions import ClientError

# Initialize the logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        # Parse request body
        data = json.loads(event['body'])
        name = data['name']
        email = data['email']
        message = data['message']

        # Basic input validation
        if not name or not email or not message:
            raise ValueError("All fields (name, email, message) are required.")

        # Initialize the SES client
        ses_client = boto3.client('ses', region_name='ap-south-1')

        # Prepare the email
        response = ses_client.send_email(
            Source='prashantmisra0510@gmail.com',  
            Destination={
                'ToAddresses': ['prashantnau2611@gmail.com'],  
            },
            Message={
                'Subject': {'Data': 'New Contact Form Submission'},
                'Body': {
                    'Text': {
                        'Data': f"Name: {name}\nEmail: {email}\nMessage: {message}"
                    }
                }
            },
            ReplyToAddresses=[email]  
        )

        # Log success
        logger.info(f"Email sent! Message ID: {response['MessageId']}")

        # Return API response
        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Form submitted successfully!"}),
            "headers": {
                "Access-Control-Allow-Origin": "*",  # Add CORS headers if needed
                "Access-Control-Allow-Headers": "Content-Type"
            }
        }

    except ClientError as e:
        logger.error(f"SES Error: {e.response['Error']['Message']}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Failed to send email"}),
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type"
            }
        }

    except Exception as e:
        logger.error(f"Error submitting contact form: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
