output "id" {
  description = "The ID of the external location"
  value       = databricks_external_location.this.id
}

output "name" {
  description = "The name of the external location"
  value       = databricks_external_location.this.name
}

output "url" {
  description = "The URL of the external location"
  value       = databricks_external_location.this.url
}