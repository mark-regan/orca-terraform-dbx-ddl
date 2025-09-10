module "feed_step_instance_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.runtime_schema_name
  table_name     = "feed_step_instance"
  table_comment  = "Tracks step executions - records individual step performance and status within feed runs"
  enable_cdf     = var.enable_cdf_for_runtime
  primary_key    = ["feed_step_instance_id"]

  columns = [
    {
      name     = "feed_step_instance_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for this step execution instance"
    },
    {
      name     = "feed_instance_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed_instance.feed_instance_id"
    },
    {
      name     = "feed_step_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to orca_metadata.feed_step.feed_step_id"
    },
    {
      name     = "step_execution_order"
      type     = "INTEGER"
      nullable = false
      comment  = "Execution order of this step within the feed instance"
    },
    {
      name     = "started_at"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when step execution started"
    },
    {
      name     = "completed_at"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when step execution completed"
    },
    {
      name     = "status"
      type     = "STRING"
      nullable = false
      comment  = "Step execution status (running, success, failed, skipped, cancelled)"
    },
    {
      name     = "retry_count"
      type     = "INTEGER"
      nullable = false
      comment  = "Number of retry attempts for this step"
    },
    {
      name     = "duration_seconds"
      type     = "BIGINT"
      nullable = true
      comment  = "Step execution duration in seconds"
    },
    {
      name     = "records_processed"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records processed by this step"
    },
    {
      name     = "records_input"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of input records to this step"
    },
    {
      name     = "records_output"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of output records from this step"
    },
    {
      name     = "bytes_read"
      type     = "BIGINT"
      nullable = true
      comment  = "Bytes read during step execution"
    },
    {
      name     = "bytes_written"
      type     = "BIGINT"
      nullable = true
      comment  = "Bytes written during step execution"
    },
    {
      name     = "cpu_time_seconds"
      type     = "DOUBLE"
      nullable = true
      comment  = "CPU time consumed in seconds"
    },
    {
      name     = "memory_peak_mb"
      type     = "DOUBLE"
      nullable = true
      comment  = "Peak memory usage in megabytes"
    },
    {
      name     = "spark_application_id"
      type     = "STRING"
      nullable = true
      comment  = "Spark application ID if using Spark engine"
    },
    {
      name     = "task_id"
      type     = "STRING"
      nullable = true
      comment  = "External task/job identifier"
    },
    {
      name     = "error_message"
      type     = "STRING"
      nullable = true
      comment  = "Error message if step failed"
    },
    {
      name     = "error_details"
      type     = "STRING"
      nullable = true
      comment  = "Detailed error information and stack trace (JSON)"
    },
    {
      name     = "step_config_used"
      type     = "STRING"
      nullable = true
      comment  = "Actual configuration used during execution (JSON)"
    },
    {
      name     = "checkpoint_data"
      type     = "STRING"
      nullable = true
      comment  = "Checkpoint data for resumable execution (JSON)"
    }
  ]
}