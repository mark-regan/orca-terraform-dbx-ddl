module "alert_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.orca_metadata_schema
  table_name     = "alert"
  table_comment  = "Master alert definition table - contains all alert configurations and rules for the ORCA platform"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["alert_id"]

  columns = [
    {
      name     = "alert_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the alert"
    },
    {
      name     = "alert_name"
      type     = "STRING"
      nullable = false
      comment  = "Human-readable name of the alert"
    },
    {
      name     = "alert_description"
      type     = "STRING"
      nullable = true
      comment  = "Detailed description of what this alert monitors"
    },
    {
      name     = "alert_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of alert (failure, warning, threshold, data_quality)"
    },
    {
      name     = "alert_category"
      type     = "STRING"
      nullable = false
      comment  = "Category of alert (operational, business, data_quality, performance)"
    },
    {
      name     = "severity_level"
      type     = "STRING"
      nullable = false
      comment  = "Severity level (critical, high, medium, low)"
    },
    {
      name     = "notification_channels"
      type     = "STRING"
      nullable = false
      comment  = "JSON array of notification channels (email, teams, slack, pagerduty)"
    },
    {
      name     = "alert_condition"
      type     = "STRING"
      nullable = false
      comment  = "SQL or expression defining when alert should trigger"
    },
    {
      name     = "threshold_value"
      type     = "DOUBLE"
      nullable = true
      comment  = "Numeric threshold value for threshold-based alerts"
    },
    {
      name     = "threshold_operator"
      type     = "STRING"
      nullable = true
      comment  = "Comparison operator for threshold (gt, lt, gte, lte, eq, ne)"
    },
    {
      name     = "cooldown_period_minutes"
      type     = "INTEGER"
      nullable = false
      comment  = "Minimum time between alert notifications in minutes"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this alert is currently active"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this alert was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this alert"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this alert was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this alert"
    }
  ]
}