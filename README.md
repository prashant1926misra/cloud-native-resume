# AWS Serverless Portfolio with CI/CD


##  Problem Statement
Building a modern, cloud-native portfolio application that is scalable, automated, and cost-efficient is challenging. Common challenges includes:
- Hosting applications with global reach and minimal cost
- Automating deployments without complex third-party tools
- Implementing serverless backends and data storage
- Demonstrating real-world AWS skills without over-engineering


## Solution Overview
This project delivers a fully AWS-native portfolio website that showcases:
- Static hosting (Amazon S3)
- Serverless APIs (API Gateway + Lambda)
- NoSQL database integration (DynamoDB)
- CI/CD automation (CodePipeline + CodeBuild)
- Infrastructure as Code (Terraform)


##  Project Goals
| Phase | Objective |
|-------|-----------|
| **Phase 1** | Host a static website using Amazon S3 provisioned via Terraform |
| **Phase 2** | Add a serverless contact form (API Gateway + Lambda + SES) |
| **Phase 3** | Implement visitor counter with DynamoDB and Lambda |
| **Phase 4** | Automate deployments using CodePipeline and CodeBuild |


##  Tools & Technologies
- Cloud Provider:
![AWS](https://img.shields.io/badge/Amazon_AWS-232F3E.svg?style=flat&logo=amazon-aws&logoColor=white)
- Infra as Code:
![Terraform](https://img.shields.io/badge/Terraform-623CE4.svg?style=flat&logo=terraform&logoColor=white)
- Storage:
![S3](https://img.shields.io/badge/Amazon_S3-569A31.svg?style=flat&logo=amazon-s3&logoColor=white)
- API Gateway:
![API Gateway](https://img.shields.io/badge/Amazon_API_Gateway-FF4F8B.svg?style=flat&logo=amazon-api-gateway&logoColor=white)
- CI/CD:
![CodePipeline](https://img.shields.io/badge/AWS_CodePipeline-46B3E6.svg?style=flat&logo=amazon-aws&logoColor=white)
![CodeBuild](https://img.shields.io/badge/AWS_CodeBuild-5391FE.svg?style=flat&logo=amazon-aws&logoColor=white)
- Email Service:
![SES](https://img.shields.io/badge/AWS_SES-FF9900.svg?style=flat&logo=amazon-ses&logoColor=white)
- Database:
![DynamoDB](https://img.shields.io/badge/Amazon_DynamoDB-4053D6.svg?style=flat&logo=amazon-dynamodb&logoColor=white)
- Amazon CloudWatch:
![Amazon CloudWatch](https://img.shields.io/badge/Amazon_CloudWatch-FF9900.svg?style=flat&logo=amazon-cloudwatch&logoColor=white)
- Amazon_Secrets_Manager:
![Amazon_Secrets_Manager](https://img.shields.io/badge/Amazon_Secrets_Manager-232F3E.svg?style=flat&logo=amazon-secrets-manager&logoColor=white)


##  Architecture Diagram

<img width="897" height="531" alt="image" src="https://github.com/user-attachments/assets/0dc597b3-5bcb-4912-9f1a-06b6be270183" />


##  Project Structure

```text
cloud-native-resume/
├── static-website/           # Phase 1
├── contact-form/             # Phase 2
├── visitor-counter/          # Phase 3
├── ci-cd/                    # Phase 4
└── README.md
```
