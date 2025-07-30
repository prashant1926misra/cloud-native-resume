# CI/CD Pipeline for Static Website Deployment

This phase sets up a fully automated CI/CD pipeline for the static resume website using AWS-native services, managed through Terraform. The pipeline ensures that any changes pushed to the configured branch on GitHub automatically update the static website hosted on Amazon S3.

## What it Does ?

- Watches the configured branch of GitHub repository for changes
- Automatically triggers a CodePipeline when updates are pushed
- Uses CodeBuild to run a buildspec.yml script that syncs website files to S3
- Deploys the updated website to the S3 static website bucket without manual steps

## Tech Stack and AWS Services Used

| Service                     | Purpose                                          |
| --------------------------- | ------------------------------------------------ |
| **Terraform**               | Infrastructure as Code (IaC)                     |
| **AWS CodePipeline**        | Automates pipeline from source → build → deploy  |
| **AWS CodeBuild**           | Executes the `buildspec.yml` to sync to S3       |
| **Amazon S3 (Static Site)** | Hosts the static resume website                  |
| **AWS Secrets Manager**     | Securely stores the GitHub token for pipeline    |
| **IAM**                     | Role-based access for CodePipeline and CodeBuild |


## Pipeline Details

- Trigger – A push to the configured branch on GitHub
- Source Stage – CodePipeline pulls the latest code from the repository using a GitHub token from AWS Secrets Manager
- Build Stage – CodeBuild runs the buildspec.yml:
```bash
    aws s3 sync static-website/website/ s3://cloud-resume-static-bucket --delete  
```
- Deploy – Updated files are pushed to the S3 bucket hosting the website

## Project Structure

```text
ci-cd/
├── buildspec.yml
└── terraform
    ├── main.tf
    ├── outputs.tf
    ├── terraform.tfvars
    ├── variables.tf
```

## Screenshots

### Terraform apply output
<img width="525" height="135" alt="image" src="https://github.com/user-attachments/assets/4bf39a0b-9287-431d-95fd-1323a2db06ac" />

### CodePipeline Console – static-site-pipeline
<img width="1232" height="411" alt="image" src="https://github.com/user-attachments/assets/3c37b321-afbe-4fe6-99db-298b1fa8cc31" />

### CodeBuild Console – Successful Build Logs
<img width="1086" height="557" alt="image" src="https://github.com/user-attachments/assets/01764f18-38c9-48c1-8c46-c495775923d4" />

### AWS Secrets Manager Console – GitHub Token
<img width="1345" height="264" alt="image" src="https://github.com/user-attachments/assets/5c5bd638-9ec1-4214-87ea-587921a0ceba" />
<img width="1295" height="235" alt="image" src="https://github.com/user-attachments/assets/b71cc6ef-f1b5-4532-93df-56c7a13e9b53" />
