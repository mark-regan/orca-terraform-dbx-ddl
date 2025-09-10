module "feed_dependencies_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.orca_metadata_schema
  table_name     = "feed_dependencies"
  table_comment  = "Defines relationships between feeds - tracks which feeds depend on other feeds for execution order"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["dependent_feed_id", "prerequisite_feed_id"]

  columns = [
    {
      name     = "dependent_feed_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed.feed_id - the feed that depends on another feed"
    },
    {
      name     = "prerequisite_feed_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed.feed_id - the feed that must complete first"
    },
    {
      name     = "dependency_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of dependency (hard, soft, conditional)"
    },
    {
      name     = "dependency_condition"
      type     = "STRING"
      nullable = true
      comment  = "Optional condition that must be met for dependency (SQL expression or status)"
    },
    {
      name     = "wait_timeout_minutes"
      type     = "INTEGER"
      nullable = true
      comment  = "Maximum time to wait for prerequisite feed to complete (minutes)"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this dependency is currently active"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this dependency was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this dependency"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this dependency was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this dependency"
    }
  ]
}