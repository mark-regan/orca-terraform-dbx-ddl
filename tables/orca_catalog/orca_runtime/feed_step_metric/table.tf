module "feed_step_metric_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.runtime_schema_name
  table_name     = "feed_step_metric"
  table_comment  = "Performance and business metrics - tracks detailed metrics captured during feed step execution"
  enable_cdf     = var.enable_cdf_for_runtime
  primary_key    = ["metric_id"]

  columns = [
    {
      name     = "metric_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for this metric record"
    },
    {
      name     = "feed_step_instance_id"
      type     = "STRING"
      nullable = false
      comment  = "Foreign key reference to feed_step_instance.feed_step_instance_id"
    },
    {
      name     = "metric_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of the metric"
    },
    {
      name     = "metric_category"
      type     = "STRING"
      nullable = false
      comment  = "Category of metric (performance, business, technical, data_quality)"
    },
    {
      name     = "metric_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of metric (counter, gauge, histogram, timer, ratio)"
    },
    {
      name     = "metric_value"
      type     = "DOUBLE"
      nullable = false
      comment  = "Numeric value of the metric"
    },
    {
      name     = "metric_unit"
      type     = "STRING"
      nullable = true
      comment  = "Unit of measurement (seconds, bytes, count, percent, etc.)"
    },
    {
      name     = "metric_description"
      type     = "STRING"
      nullable = true
      comment  = "Description of what this metric measures"
    },
    {
      name     = "dataset_id"
      type     = "STRING"
      nullable = true
      comment  = "Related dataset if metric is dataset-specific"
    },
    {
      name     = "column_name"
      type     = "STRING"
      nullable = true
      comment  = "Related column if metric is column-specific"
    },
    {
      name     = "dimension_1_name"
      type     = "STRING"
      nullable = true
      comment  = "First dimension name for multi-dimensional metrics"
    },
    {
      name     = "dimension_1_value"
      type     = "STRING"
      nullable = true
      comment  = "First dimension value"
    },
    {
      name     = "dimension_2_name"
      type     = "STRING"
      nullable = true
      comment  = "Second dimension name for multi-dimensional metrics"
    },
    {
      name     = "dimension_2_value"
      type     = "STRING"
      nullable = true
      comment  = "Second dimension value"
    },
    {
      name     = "dimension_3_name"
      type     = "STRING"
      nullable = true
      comment  = "Third dimension name for multi-dimensional metrics"
    },
    {
      name     = "dimension_3_value"
      type     = "STRING"
      nullable = true
      comment  = "Third dimension value"
    },
    {
      name     = "timestamp_collected"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when metric was collected"
    },
    {
      name     = "collection_method"
      type     = "STRING"
      nullable = false
      comment  = "How metric was collected (calculated, measured, estimated, provided)"
    },
    {
      name     = "baseline_value"
      type     = "DOUBLE"
      nullable = true
      comment  = "Baseline or expected value for comparison"
    },
    {
      name     = "threshold_warning"
      type     = "DOUBLE"
      nullable = true
      comment  = "Warning threshold value"
    },
    {
      name     = "threshold_critical"
      type     = "DOUBLE"
      nullable = true
      comment  = "Critical threshold value"
    },
    {
      name     = "is_anomaly"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this metric value is considered anomalous"
    },
    {
      name     = "anomaly_score"
      type     = "DOUBLE"
      nullable = true
      comment  = "Anomaly detection score (0-1, higher = more anomalous)"
    },
    {
      name     = "tags"
      type     = "STRING"
      nullable = true
      comment  = "Metric tags for grouping and filtering (JSON object)"
    },
    {
      name     = "metric_metadata"
      type     = "STRING"
      nullable = true
      comment  = "Additional metric metadata (JSON)"
    }
  ]
}