module "dataset_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.orca_metadata_schema
  table_name     = "dataset"
  table_comment  = "Master dataset registry - contains metadata for all datasets used across the ORCA platform"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["dataset_id"]

  columns = [
    {
      name     = "dataset_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the dataset"
    },
    {
      name     = "dataset_name"
      type     = "STRING"
      nullable = false
      comment  = "Human-readable name of the dataset"
    },
    {
      name     = "dataset_description"
      type     = "STRING"
      nullable = true
      comment  = "Detailed description of the dataset content and purpose"
    },
    {
      name     = "dataset_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of dataset (source, intermediate, target, reference)"
    },
    {
      name     = "data_layer"
      type     = "STRING"
      nullable = false
      comment  = "Data layer (bronze, silver, gold, platinum)"
    },
    {
      name     = "catalog_name"
      type     = "STRING"
      nullable = false
      comment  = "Unity Catalog name where dataset resides"
    },
    {
      name     = "schema_name"
      type     = "STRING"
      nullable = false
      comment  = "Schema name where dataset resides"
    },
    {
      name     = "table_name"
      type     = "STRING"
      nullable = false
      comment  = "Table name of the dataset"
    },
    {
      name     = "data_format"
      type     = "STRING"
      nullable = false
      comment  = "Physical data format (delta, parquet, json, csv)"
    },
    {
      name     = "storage_location"
      type     = "STRING"
      nullable = true
      comment  = "Physical storage path for the dataset"
    },
    {
      name     = "partition_columns"
      type     = "STRING"
      nullable = true
      comment  = "JSON array of partition column names"
    },
    {
      name     = "data_classification"
      type     = "STRING"
      nullable = false
      comment  = "Data sensitivity classification (public, internal, confidential, restricted)"
    },
    {
      name     = "retention_days"
      type     = "INTEGER"
      nullable = true
      comment  = "Data retention period in days"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this dataset is currently active"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this dataset was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this dataset"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this dataset was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this dataset"
    }
  ]
}