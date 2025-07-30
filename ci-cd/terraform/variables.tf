variable "github_owner" {
  description = "GitHub username or org"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to track"
  type        = string
  default     = "main"
}

variable "s3_bucket_name" {
  description = "S3 bucket for static site"
  type        = string
}
