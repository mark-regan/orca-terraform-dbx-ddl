module "feed_instance_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.orca_catalog_name
  schema_name    = var.runtime_schema_name
  table_name     = "feed_instance"
  table_comment  = "Tracks individual feed executions - records each time a feed runs with status and metrics"
  enable_cdf     = var.enable_cdf_for_runtime
  primary_key    = ["feed_instance_id"]

  columns = [
    {
      name     = "feed_instance_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for this feed execution instance"
    },
    {
      name     = "feed_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to orca_metadata.feed.feed_id"
    },
    {
      name     = "schedule_id"
      type     = "STRING"
      nullable = true
      comment  = "Foreign key reference to feed_schedule.schedule_id (null for manual runs)"
    },
    {
      name     = "execution_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Logical date/time this execution represents"
    },
    {
      name     = "started_at"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Actual timestamp when execution started"
    },
    {
      name     = "completed_at"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when execution completed (success or failure)"
    },
    {
      name     = "status"
      type     = "STRING"
      nullable = false
      comment  = "Current execution status (running, success, failed, cancelled, retrying)"
    },
    {
      name     = "triggered_by"
      type     = "STRING"
      nullable = false
      comment  = "What triggered this execution (schedule, manual, dependency, retry)"
    },
    {
      name     = "triggered_by_user"
      type     = "STRING"
      nullable = true
      comment  = "User who triggered manual execution"
    },
    {
      name     = "execution_mode"
      type     = "STRING"
      nullable = false
      comment  = "Execution mode (full, incremental, backfill, test)"
    },
    {
      name     = "cluster_id"
      type     = "STRING"
      nullable = true
      comment  = "Databricks cluster ID used for execution"
    },
    {
      name     = "job_run_id"
      type     = "STRING"
      nullable = true
      comment  = "External job/workflow run identifier"
    },
    {
      name     = "total_steps"
      type     = "INTEGER"
      nullable = false
      comment  = "Total number of steps in this feed execution"
    },
    {
      name     = "completed_steps"
      type     = "INTEGER"
      nullable = false
      comment  = "Number of steps completed successfully"
    },
    {
      name     = "failed_steps"
      type     = "INTEGER"
      nullable = false
      comment  = "Number of steps that failed"
    },
    {
      name     = "retry_count"
      type     = "INTEGER"
      nullable = false
      comment  = "Number of retry attempts for this instance"
    },
    {
      name     = "duration_seconds"
      type     = "BIGINT"
      nullable = true
      comment  = "Total execution duration in seconds"
    },
    {
      name     = "records_processed"
      type     = "BIGINT"
      nullable = true
      comment  = "Total number of records processed"
    },
    {
      name     = "bytes_processed"
      type     = "BIGINT"
      nullable = true
      comment  = "Total bytes processed"
    },
    {
      name     = "error_message"
      type     = "STRING"
      nullable = true
      comment  = "Error message if execution failed"
    },
    {
      name     = "error_details"
      type     = "STRING"
      nullable = true
      comment  = "Detailed error information (JSON)"
    },
    {
      name     = "execution_config"
      type     = "STRING"
      nullable = true
      comment  = "Runtime configuration used for this execution (JSON)"
    }
  ]
}