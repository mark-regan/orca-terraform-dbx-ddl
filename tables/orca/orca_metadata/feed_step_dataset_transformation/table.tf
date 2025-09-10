module "feed_step_dataset_transformation_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.orca_metadata_schema
  table_name     = "feed_step_dataset_transformation"
  table_comment  = "Column level transformations - defines specific transformations applied to dataset columns during processing"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["transformation_id"]

  columns = [
    {
      name     = "transformation_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the transformation rule"
    },
    {
      name     = "feed_step_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed_step.feed_step_id"
    },
    {
      name     = "source_dataset_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to dataset.dataset_id for source dataset"
    },
    {
      name     = "target_dataset_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to dataset.dataset_id for target dataset"
    },
    {
      name     = "source_column_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of the source column being transformed"
    },
    {
      name     = "target_column_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of the target column after transformation"
    },
    {
      name     = "transformation_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of transformation (map, cast, calculate, lookup, hash, encrypt)"
    },
    {
      name     = "transformation_expression"
      type     = "STRING"
      nullable = true
      comment  = "SQL expression or function for the transformation"
    },
    {
      name     = "transformation_config"
      type     = "STRING"
      nullable = true
      comment  = "Additional transformation configuration (JSON)"
    },
    {
      name     = "data_quality_rules"
      type     = "STRING"
      nullable = true
      comment  = "Data quality validation rules for transformed column (JSON)"
    },
    {
      name     = "execution_order"
      type     = "INTEGER"
      nullable = false
      comment  = "Order in which transformations should be applied"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this transformation is currently active"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this transformation was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this transformation"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this transformation was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this transformation"
    }
  ]
}