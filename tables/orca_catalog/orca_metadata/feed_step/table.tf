module "feed_step_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.metadata_schema_name
  table_name     = "feed_step"
  table_comment  = "Individual processing steps within feeds - defines the sequence of operations for each feed"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["feed_step_id"]

  columns = [
    {
      name     = "feed_step_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the feed step"
    },
    {
      name     = "feed_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed.feed_id"
    },
    {
      name     = "step_name"
      type     = "STRING"
      nullable = false
      comment  = "Human-readable name of the processing step"
    },
    {
      name     = "step_description"
      type     = "STRING"
      nullable = true
      comment  = "Detailed description of what this step does"
    },
    {
      name     = "step_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of step (extract, transform, load, validate, enrich, aggregate)"
    },
    {
      name     = "execution_order"
      type     = "INTEGER"
      nullable = false
      comment  = "Order in which this step should be executed within the feed"
    },
    {
      name     = "execution_engine"
      type     = "STRING"
      nullable = false
      comment  = "Engine to execute this step (spark, databricks, python, sql)"
    },
    {
      name     = "step_code"
      type     = "STRING"
      nullable = true
      comment  = "Code or script to execute for this step"
    },
    {
      name     = "step_config"
      type     = "STRING"
      nullable = true
      comment  = "Step-specific configuration (JSON)"
    },
    {
      name     = "retry_count"
      type     = "INTEGER"
      nullable = false
      comment  = "Number of retry attempts for failed steps"
    },
    {
      name     = "retry_delay_seconds"
      type     = "INTEGER"
      nullable = false
      comment  = "Delay between retry attempts in seconds"
    },
    {
      name     = "timeout_minutes"
      type     = "INTEGER"
      nullable = true
      comment  = "Maximum execution time for this step in minutes"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this step is currently active"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this step was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this step"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this step was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this step"
    }
  ]
}