module "feed_schedule_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.runtime_schema_name
  table_name     = "feed_schedule"
  table_comment  = "Schedule configurations for feeds - defines when and how frequently feeds should execute"
  enable_cdf     = var.enable_cdf_for_runtime
  primary_key    = ["schedule_id"]

  columns = [
    {
      name     = "schedule_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the schedule configuration"
    },
    {
      name     = "feed_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to orca_metadata.feed.feed_id"
    },
    {
      name     = "schedule_name"
      type     = "STRING"
      nullable = false
      comment  = "Human-readable name for the schedule"
    },
    {
      name     = "schedule_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of schedule (cron, interval, manual, event_driven)"
    },
    {
      name     = "cron_expression"
      type     = "STRING"
      nullable = true
      comment  = "Cron expression for scheduled execution"
    },
    {
      name     = "interval_minutes"
      type     = "INTEGER"
      nullable = true
      comment  = "Interval in minutes for recurring execution"
    },
    {
      name     = "timezone"
      type     = "STRING"
      nullable = false
      comment  = "Timezone for schedule execution (e.g., Europe/London)"
    },
    {
      name     = "start_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Date and time when schedule becomes active"
    },
    {
      name     = "end_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Date and time when schedule expires (null for indefinite)"
    },
    {
      name     = "max_concurrent_runs"
      type     = "INTEGER"
      nullable = false
      comment  = "Maximum number of concurrent executions allowed"
    },
    {
      name     = "priority"
      type     = "INTEGER"
      nullable = false
      comment  = "Execution priority (1=highest, 10=lowest)"
    },
    {
      name     = "skip_on_holiday"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether to skip execution on bank holidays"
    },
    {
      name     = "holiday_region"
      type     = "STRING"
      nullable = true
      comment  = "Holiday region to check (must match holiday_calendar.region)"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this schedule is currently active"
    },
    {
      name     = "schedule_config"
      type     = "STRING"
      nullable = true
      comment  = "Additional schedule configuration (JSON)"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this schedule was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this schedule"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this schedule was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this schedule"
    }
  ]
}