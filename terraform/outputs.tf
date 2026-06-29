output "project_id" {
  description = "dbt platform project ID — use this when connecting your git repository."
  value       = dbtcloud_project.demo.id
}

output "dev_environment_id" {
  description = "Development environment ID for IDE / dbt Cloud CLI connections."
  value       = dbtcloud_environment.dev.environment_id
}

output "prod_environment_id" {
  description = "Production environment ID for job scheduling."
  value       = dbtcloud_environment.prod.environment_id
}
