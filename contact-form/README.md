# Serverless Contact Form API

This phase builds a serverless backend for a contact form using AWS-native services, fully managed through Terraform. It handles form submissions, sends emails via Amazon SES, and runs entirely on AWS Lambda.


## What It Does ?
- Exposes a REST API endpoint to receive contact form submissions
- Sends the submitted message to an email address using Amazon SES


## Tech Stack and AWS Services Used

| Service          | Purpose                                 |
|------------------|-----------------------------------------|
| **Terraform**    | Infrastructure as Code (IaC)            |
| **AWS Lambda**   | Runs contact form processing logic      |
| **AWS API Gateway (HTTP)** | Exposes a REST endpoint for the contact form |
| **AWS SES**      | Sends contact form submissions as email |
| **IAM**          | Secure role-based access for Lambda     |
| **CloudWatch**   | Logs Lambda execution and errors        |


## API Details

### Endpoint -

`POST /contact` (Full URL provided by Terraform output)

### Headers -
`Content-Type: application/json`

### Example Payload -

```json
{
    "name": "Neo",
    "email": "neo@example.com",
    "message": "Hello from the contact form!"
}
```
### Expected Output -
 
```json
{
    "message": "Form submitted successfully"
}
```
### Test the API -

```bash
curl -X POST https://<your-api-id>.execute-api.<region>.amazonaws.com/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Neo",
    "email": "neo@example.com",
    "message": "Hello from the contact form!"
  }'
```
#### Note: Replace `<your-api-id>` and `<region>` with the actual values from the Terraform output.

## Project Structure

```text
contact-form/
├── lambda/
│   ├── main.py
│   └── requirements.txt
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── iam.tf
│   └── terraform.tfstate
└── README.md
```


## Screenshots

### Terraform apply output 
<img width="979" height="337" alt="image" src="https://github.com/user-attachments/assets/5b65b714-12bb-4f67-983e-3fdac389c6d4" />

### API Gateway Console – ContactFormAPI
<img width="979" height="387" alt="image" src="https://github.com/user-attachments/assets/80b1a21a-010f-4d6b-9106-4f0f7845388d" />

### Lambda Console – Function Overview
<img width="979" height="285" alt="image" src="https://github.com/user-attachments/assets/59a90e87-126e-412f-a4c6-7162eb4147c6" />
<img width="979" height="418" alt="image" src="https://github.com/user-attachments/assets/7df7740c-22e8-483f-b528-64b100608c45" />

### CloudWatch Logs
<img width="979" height="260" alt="image" src="https://github.com/user-attachments/assets/ce7bdd89-f822-4f75-ba5a-69cca2f2ee06" />

### Successful curl Response
<img width="979" height="95" alt="image" src="https://github.com/user-attachments/assets/828e2917-6044-40d1-b251-012a0dacb2ac" />

