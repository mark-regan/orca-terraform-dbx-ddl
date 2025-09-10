module "feed_alert_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.orca_metadata_schema
  table_name     = "feed_alert"
  table_comment  = "Maps feeds to alert configurations - defines which alerts are active for each feed"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["feed_id", "alert_id"]

  columns = [
    {
      name     = "feed_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed.feed_id"
    },
    {
      name     = "alert_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to alert.alert_id"
    },
    {
      name     = "is_enabled"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this alert is enabled for this specific feed"
    },
    {
      name     = "custom_threshold_value"
      type     = "DOUBLE"
      nullable = true
      comment  = "Feed-specific override for alert threshold value"
    },
    {
      name     = "custom_notification_channels"
      type     = "STRING"
      nullable = true
      comment  = "Feed-specific override for notification channels (JSON array)"
    },
    {
      name     = "custom_cooldown_period_minutes"
      type     = "INTEGER"
      nullable = true
      comment  = "Feed-specific override for cooldown period in minutes"
    },
    {
      name     = "alert_context"
      type     = "STRING"
      nullable = true
      comment  = "Additional context or metadata for this alert mapping (JSON)"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this alert mapping was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this alert mapping"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this alert mapping was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this alert mapping"
    }
  ]
}