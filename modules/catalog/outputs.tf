output "id" {
  description = "The ID of the catalog"
  value       = databricks_catalog.this.id
}

output "name" {
  description = "The name of the catalog"
  value       = databricks_catalog.this.name
}

output "schema_ids" {
  description = "Map of schema names to their IDs"
  value = {
    for schema_name, schema in databricks_schema.schemas : schema_name => schema.id
  }
}

output "schema_names" {
  description = "Map of schema names to their full qualified names"
  value = {
    for schema_name, schema in databricks_schema.schemas : schema_name => "${databricks_catalog.this.name}.${schema_name}"
  }
}