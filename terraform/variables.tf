variable "project_display_name" {
  description = "Human-readable project name used in dbt platform resource names."
  type        = string
  default     = "Grocery Ops"
}

variable "dbt_account_id" {
  description = "dbt platform account ID. Found in Account Settings → Account."
  type        = number
}

variable "dbt_service_token" {
  description = "dbt platform service token with Account Admin or Developer permissions."
  type        = string
  sensitive   = true
}
