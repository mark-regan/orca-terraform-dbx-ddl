module "platform_stop_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.runtime_schema_name
  table_name     = "platform_stop"
  table_comment  = "Emergency stop controls - manages emergency stop conditions and circuit breakers for ORCA platform"
  enable_cdf     = var.enable_cdf_for_runtime
  primary_key    = ["stop_id"]

  columns = [
    {
      name     = "stop_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the stop control"
    },
    {
      name     = "stop_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of stop (emergency, maintenance, circuit_breaker, throttle)"
    },
    {
      name     = "stop_scope"
      type     = "STRING"
      nullable = false
      comment  = "Scope of stop (platform, feed, step, dataset, system)"
    },
    {
      name     = "target_id"
      type     = "STRING"
      nullable = true
      comment  = "ID of specific target (feed_id, dataset_id, etc.) if scoped"
    },
    {
      name     = "target_name"
      type     = "STRING"
      nullable = true
      comment  = "Human-readable name of the target"
    },
    {
      name     = "stop_reason"
      type     = "STRING"
      nullable = false
      comment  = "Reason for the stop"
    },
    {
      name     = "stop_description"
      type     = "STRING"
      nullable = true
      comment  = "Detailed description of the stop condition"
    },
    {
      name     = "severity"
      type     = "STRING"
      nullable = false
      comment  = "Severity level (critical, high, medium, low)"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether the stop is currently active"
    },
    {
      name     = "started_at"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when stop was activated"
    },
    {
      name     = "ended_at"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when stop was deactivated"
    },
    {
      name     = "auto_resume_at"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when stop should automatically resume (if applicable)"
    },
    {
      name     = "activated_by"
      type     = "STRING"
      nullable = false
      comment  = "User or system that activated the stop"
    },
    {
      name     = "deactivated_by"
      type     = "STRING"
      nullable = true
      comment  = "User or system that deactivated the stop"
    },
    {
      name     = "affects_new_runs"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether stop prevents new executions from starting"
    },
    {
      name     = "affects_running_jobs"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether stop cancels currently running jobs"
    },
    {
      name     = "notification_sent"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether notifications have been sent about this stop"
    },
    {
      name     = "notification_channels"
      type     = "STRING"
      nullable = true
      comment  = "Notification channels used (JSON array)"
    },
    {
      name     = "override_conditions"
      type     = "STRING"
      nullable = true
      comment  = "Conditions under which stop can be overridden (JSON)"
    },
    {
      name     = "circuit_breaker_config"
      type     = "STRING"
      nullable = true
      comment  = "Circuit breaker configuration if applicable (JSON)"
    },
    {
      name     = "recovery_steps"
      type     = "STRING"
      nullable = true
      comment  = "Steps required for recovery (JSON array)"
    },
    {
      name     = "impact_assessment"
      type     = "STRING"
      nullable = true
      comment  = "Assessment of business impact (JSON)"
    },
    {
      name     = "related_incidents"
      type     = "STRING"
      nullable = true
      comment  = "Related incident IDs or references (JSON array)"
    },
    {
      name     = "stop_metadata"
      type     = "STRING"
      nullable = true
      comment  = "Additional metadata about the stop condition (JSON)"
    }
  ]
}