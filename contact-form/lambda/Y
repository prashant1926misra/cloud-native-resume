import json
import os
import logging
import boto3

# Initialize the logger
logger = logging.getLogger()
logger.setLevel("INFO")

def lambda_handler(event, context):
    try:
        name = event['name']
        email = event['email']
        message = event['message']

        return {  # Success response
            "statusCode": 200,
            "body": json.dumps({"message": "Form submitted!"})
        }

    except Exception as e:
        logger.error(f"Error submitting contact form: {str(e)}")
        return {  # Error response
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
