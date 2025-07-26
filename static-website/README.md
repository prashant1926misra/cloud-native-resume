  # Static Resume Website Hosting
  
  This phase involves deploying a static resume or portfolio website using Amazon S3, with all infrastructure provisioned through Terraform. The result is a publicly accessible website, served directly from an S3 bucket via a globally available endpoint.

  ## What It Does ?
- Hosts a static website (e.g., HTML resume or portfolio)
- Provisions an S3 bucket with static website hosting enabled
- Uploads the `index.html` page to the S3 bucket
- Outputs a public website URL that can be accessed via browser or curl


## Tech Stack and AWS Services Used

| Service          | Purpose                                 |
|------------------|-----------------------------------------|
| **Terraform**    | Infrastructure as Code (IaC)            |
| **Amazon S3**    | Runs contact form processing logic      |
| **IAM**          | Allows S3 access                        |


## Website Access

### URL Output -
Provided by Terraform output as:
http://cloud-resume-static-bucket.s3-website.ap-south-1.amazonaws.com

### Test the Website -
Open in your browser or use curl:
```bash
curl -kv http://cloud-resume-static-bucket.s3-website.<region>.amazonaws.com
```
#### Note: Replace ```<region>``` with the actual AWS region (e.g., ap-south-1 for Mumbai).

## Project Structure

```text
static-website/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── outputs.tf
├── README.md
└── website/
    └── index.html
```

## Screenshots

### Terraform apply output 
<img width="979" height="337" alt="image" src="https://github.com/user-attachments/assets/5b65b714-12bb-4f67-983e-3fdac389c6d4" />

### S3 Console – Bucket Overview
<img width="1092" height="363" alt="image" src="https://github.com/user-attachments/assets/38ead2b2-acf7-4a6b-8d94-e430a4f56bbe" />

### Successful curl Response
<img width="1284" height="418" alt="image" src="https://github.com/user-attachments/assets/de931464-590d-4200-b270-45571a3ff5ea" />
