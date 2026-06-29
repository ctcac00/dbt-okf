terraform {
  required_providers {
    dbtcloud = {
      source  = "dbt-labs/dbtcloud"
      version = "~> 0.3"
    }
  }
}

provider "dbtcloud" {
  account_id = var.dbt_account_id
  token      = var.dbt_service_token
  host_url   = "https://cloud.getdbt.com"   # or your Access URL if on a custom domain
}

resource "dbtcloud_project" "demo" {
  name = "${var.project_display_name} Demo"
}

resource "dbtcloud_environment" "dev" {
  project_id  = dbtcloud_project.demo.id
  name        = "Development"
  dbt_version = "versionless"
  type        = "development"
}

resource "dbtcloud_environment" "prod" {
  project_id  = dbtcloud_project.demo.id
  name        = "Production"
  dbt_version = "versionless"
  type        = "deployment"
}

resource "dbtcloud_job" "daily_build" {
  project_id     = dbtcloud_project.demo.id
  environment_id = dbtcloud_environment.prod.environment_id
  name           = "Daily Build"
  execute_steps  = ["dbt build"]
  schedule_type  = "every_day"
  schedule_hours = [6]
  triggers = {
    github_webhook = false
    schedule       = true
  }
}
