module "feed_step_parameter_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.orca_metadata_schema
  table_name     = "feed_step_parameter"
  table_comment  = "Step-specific configuration parameters - stores key-value parameters for each feed step"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["feed_step_id", "parameter_name"]

  columns = [
    {
      name     = "feed_step_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed_step.feed_step_id"
    },
    {
      name     = "parameter_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of the parameter"
    },
    {
      name     = "parameter_value"
      type     = "STRING"
      nullable = true
      comment  = "Value of the parameter"
    },
    {
      name     = "parameter_type"
      type     = "STRING"
      nullable = false
      comment  = "Data type of parameter (string, integer, boolean, json, encrypted)"
    },
    {
      name     = "parameter_description"
      type     = "STRING"
      nullable = true
      comment  = "Description of what this parameter controls"
    },
    {
      name     = "is_encrypted"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this parameter value is encrypted"
    },
    {
      name     = "is_required"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this parameter is required for step execution"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this parameter was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this parameter"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this parameter was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this parameter"
    }
  ]
}