module "dataset_instance_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.runtime_schema_name
  table_name     = "dataset_instance"
  table_comment  = "Tracks dataset usage - records when datasets are read/written during feed executions"
  enable_cdf     = var.enable_cdf_for_runtime
  primary_key    = ["dataset_instance_id"]

  columns = [
    {
      name     = "dataset_instance_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for this dataset usage instance"
    },
    {
      name     = "feed_step_instance_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed_step_instance.feed_step_instance_id"
    },
    {
      name     = "dataset_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to orca_metadata.dataset.dataset_id"
    },
    {
      name     = "usage_type"
      type     = "STRING"
      nullable = false
      comment  = "How dataset was used (read, write, lookup, reference)"
    },
    {
      name     = "access_mode"
      type     = "STRING"
      nullable = false
      comment  = "Access pattern (read, write, append, overwrite, merge, delete)"
    },
    {
      name     = "started_at"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when dataset access started"
    },
    {
      name     = "completed_at"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when dataset access completed"
    },
    {
      name     = "status"
      type     = "STRING"
      nullable = false
      comment  = "Access status (success, failed, partial, skipped)"
    },
    {
      name     = "records_read"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records read from dataset"
    },
    {
      name     = "records_written"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records written to dataset"
    },
    {
      name     = "records_updated"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records updated in dataset"
    },
    {
      name     = "records_deleted"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records deleted from dataset"
    },
    {
      name     = "bytes_read"
      type     = "BIGINT"
      nullable = true
      comment  = "Bytes read from dataset"
    },
    {
      name     = "bytes_written"
      type     = "BIGINT"
      nullable = true
      comment  = "Bytes written to dataset"
    },
    {
      name     = "partitions_affected"
      type     = "INTEGER"
      nullable = true
      comment  = "Number of partitions read/written"
    },
    {
      name     = "files_read"
      type     = "INTEGER"
      nullable = true
      comment  = "Number of files read"
    },
    {
      name     = "files_written"
      type     = "INTEGER"
      nullable = true
      comment  = "Number of files written"
    },
    {
      name     = "duration_seconds"
      type     = "DOUBLE"
      nullable = true
      comment  = "Duration of dataset access in seconds"
    },
    {
      name     = "filter_conditions"
      type     = "STRING"
      nullable = true
      comment  = "Filter conditions applied during read operations"
    },
    {
      name     = "partition_values"
      type     = "STRING"
      nullable = true
      comment  = "Partition values accessed (JSON array)"
    },
    {
      name     = "schema_version"
      type     = "STRING"
      nullable = true
      comment  = "Schema version at time of access"
    },
    {
      name     = "table_version"
      type     = "BIGINT"
      nullable = true
      comment  = "Delta table version at time of access"
    },
    {
      name     = "error_message"
      type     = "STRING"
      nullable = true
      comment  = "Error message if dataset access failed"
    },
    {
      name     = "access_metadata"
      type     = "STRING"
      nullable = true
      comment  = "Additional access metadata (JSON)"
    }
  ]
}