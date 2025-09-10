module "dataset_schema_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.metadata_schema_name
  table_name     = "dataset_schema"
  table_comment  = "Detailed schema definitions - stores column-level metadata for all datasets"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["dataset_id", "column_name"]

  columns = [
    {
      name     = "dataset_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to dataset.dataset_id"
    },
    {
      name     = "column_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of the column"
    },
    {
      name     = "column_position"
      type     = "INTEGER"
      nullable = false
      comment  = "Ordinal position of column in dataset"
    },
    {
      name     = "data_type"
      type     = "STRING"
      nullable = false
      comment  = "Data type of the column (STRING, INTEGER, DOUBLE, BOOLEAN, TIMESTAMP, etc.)"
    },
    {
      name     = "is_nullable"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether the column allows null values"
    },
    {
      name     = "column_description"
      type     = "STRING"
      nullable = true
      comment  = "Business description of the column content"
    },
    {
      name     = "business_name"
      type     = "STRING"
      nullable = true
      comment  = "Business-friendly name for the column"
    },
    {
      name     = "data_classification"
      type     = "STRING"
      nullable = false
      comment  = "Data sensitivity classification (public, internal, confidential, restricted, pii)"
    },
    {
      name     = "is_primary_key"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this column is part of the primary key"
    },
    {
      name     = "is_foreign_key"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this column is a foreign key"
    },
    {
      name     = "foreign_key_reference"
      type     = "STRING"
      nullable = true
      comment  = "Reference to foreign key table and column (format: table.column)"
    },
    {
      name     = "default_value"
      type     = "STRING"
      nullable = true
      comment  = "Default value for the column"
    },
    {
      name     = "validation_rules"
      type     = "STRING"
      nullable = true
      comment  = "Data validation rules for the column (JSON)"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this schema definition was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this schema definition"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this schema definition was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this schema definition"
    }
  ]
}