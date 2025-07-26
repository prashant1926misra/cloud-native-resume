# Serverless Visitor Counter API

This phase builds a serverless visitor counter backend for a resume website using AWS-native services, fully managed through Terraform. It tracks page views, stores them in DynamoDB, and exposes a REST API via API Gateway, all executed through AWS Lambda.

## What It Does ?

* Exposes a REST API endpoint to fetch and increment the visitor count
* Tracks page visits by reading and updating a DynamoDB table using a Lambda function

## Tech Stack and AWS Services Used

| Service                    | Purpose                                  |
| -------------------------- | ---------------------------------------- |
| **Terraform**              | Infrastructure as Code (IaC)             |
| **AWS Lambda**             | Logic to read/update visitor count       |
| **AWS API Gateway (HTTP)** | Exposes REST endpoint to get visit count |
| **Amazon DynamoDB**        | Stores and updates the visitor counter   |
| **IAM**                    | Secure role-based access for Lambda      |

## API Details

### Endpoint -

`GET /visits` (Full URL provided by Terraform output)

### Example Output -

```json
{
  "count": 4
}
```

If the endpoint is hit again:

```json
{
  "count": 5
}
```

### Test the API -

```bash
curl -X GET https://<your-api-id>.execute-api.<region>.amazonaws.com/visits
```

#### Note: Replace `<your-api-id>` and `<region>` with the actual values from the Terraform output.

## Project Structure

```text
visitor-counter/
├── lambda
│   └── main.py
├── README.md
└── terraform
    ├── main.tf
    ├── outputs.tf
    ├── terraform.tfvars
    └── variables.tf
```

## Screenshots

### Terraform apply output
<img width="979" height="264" alt="image" src="https://github.com/user-attachments/assets/4c1d5f47-af40-40c0-9d90-12caba23b797" />

### API Gateway Console – visitor-counter-api
<img width="1188" height="391" alt="image" src="https://github.com/user-attachments/assets/d5353778-406c-467f-83ea-e454919891bc" />

### Lambda Console – Function
<img width="1129" height="523" alt="image" src="https://github.com/user-attachments/assets/6fc3809f-0b5d-45ae-8d34-516f831f3060" />

### DynamoDB Table
<img width="1311" height="234" alt="image" src="https://github.com/user-attachments/assets/f9a81c3e-bb60-4660-be98-ee5cb3070b0a" />

### Successful curl Response
<img width="1342" height="102" alt="image" src="https://github.com/user-attachments/assets/4702892f-72a2-40a5-87d5-5f1f7fa30a68" />
