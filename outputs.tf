output "catalog_name" {
  description = "The Unity Catalog name used for ORCA tables"
  value       = var.catalog_name
}

output "metadata_schema_full_name" {
  description = "Full name of the metadata schema"
  value       = "${var.catalog_name}.${var.metadata_schema_name}"
}

output "runtime_schema_full_name" {
  description = "Full name of the runtime schema"
  value       = "${var.catalog_name}.${var.runtime_schema_name}"
}

output "metadata_tables" {
  description = "List of created metadata tables"
  value = [
    "feed",
    "feed_alert",
    "alert",
    "feed_dependencies",
    "feed_step",
    "feed_step_parameter",
    "feed_parameter",
    "dataset",
    "feed_step_dataset",
    "feed_step_dataset_transformation",
    "dataset_schema",
    "dataset_parameter",
    "holiday_calendar",
    "code_version"
  ]
}

output "runtime_tables" {
  description = "List of created runtime tables"
  value = [
    "feed_schedule",
    "feed_instance",
    "feed_step_instance",
    "dataset_instance",
    "data_quality_results",
    "feed_step_metric",
    "platform_stop"
  ]
}