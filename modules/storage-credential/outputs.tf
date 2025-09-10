output "id" {
  description = "The ID of the storage credential"
  value       = databricks_storage_credential.this.id
}

output "name" {
  description = "The name of the storage credential"
  value       = databricks_storage_credential.this.name
}