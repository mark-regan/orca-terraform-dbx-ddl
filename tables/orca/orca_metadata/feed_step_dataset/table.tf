module "feed_step_dataset_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.orca_metadata_schema
  table_name     = "feed_step_dataset"
  table_comment  = "Maps datasets to feed steps - defines which datasets are used by which processing steps"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["feed_step_id", "dataset_id", "usage_type"]

  columns = [
    {
      name     = "feed_step_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed_step.feed_step_id"
    },
    {
      name     = "dataset_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to dataset.dataset_id"
    },
    {
      name     = "usage_type"
      type     = "STRING"
      nullable = false
      comment  = "How dataset is used (input, output, lookup, reference)"
    },
    {
      name     = "dataset_alias"
      type     = "STRING"
      nullable = true
      comment  = "Alias name for dataset within the step context"
    },
    {
      name     = "access_mode"
      type     = "STRING"
      nullable = false
      comment  = "Access pattern for dataset (read, write, append, overwrite, merge)"
    },
    {
      name     = "filter_condition"
      type     = "STRING"
      nullable = true
      comment  = "Optional filter condition applied when reading dataset"
    },
    {
      name     = "column_mapping"
      type     = "STRING"
      nullable = true
      comment  = "JSON object defining column name mappings"
    },
    {
      name     = "is_required"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this dataset is required for step execution"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this mapping was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this mapping"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this mapping was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this mapping"
    }
  ]
}