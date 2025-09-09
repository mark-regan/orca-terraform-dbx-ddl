output "table_full_name" {
  description = "Full name of the created table"
  value       = "${var.catalog_name}.${var.schema_name}.${var.table_name}"
}

output "table_id" {
  description = "ID of the created table"
  value       = databricks_sql_table.this.id
}