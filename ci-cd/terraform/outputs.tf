# S3 bucket name (where website is hosted)
output "static_site_bucket" {
  description = "S3 bucket name hosting the static website"
  value       = var.s3_bucket_name
}

# CodePipeline name
output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.static_site_pipeline.name
}

# CodeBuild project name
output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.static_site_build.name
}
