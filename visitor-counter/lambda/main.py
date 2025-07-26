'''
Documentation:
https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.UpdateExpressions.html
https://github.com/awsdocs/aws-doc-sdk-examples/tree/main/python/example_code/dynamodb#code-examples
https://docs.aws.amazon.com/code-library/latest/ug/python_3_dynamodb_code_examples.html

'''

import boto3
import json

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('visitor_count_table')

    try:
        response = table.update_item(
            Key={'id': 'visits'},
            UpdateExpression='ADD #count :incr',
            ExpressionAttributeNames={'#count': 'count'},
            ExpressionAttributeValues={':incr': 1},
            ReturnValues='UPDATED_NEW'
        )

        new_count = response['Attributes']['count']

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': json.dumps({'count': int(new_count)})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
