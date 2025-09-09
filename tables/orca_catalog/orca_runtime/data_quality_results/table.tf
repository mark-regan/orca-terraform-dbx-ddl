module "data_quality_results_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.runtime_schema_name
  table_name     = "data_quality_results"
  table_comment  = "Data quality test results - stores outcomes of data quality checks performed during feed execution"
  enable_cdf     = var.enable_cdf_for_runtime
  primary_key    = ["dq_result_id"]

  columns = [
    {
      name     = "dq_result_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for this data quality test result"
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
      name     = "test_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of the data quality test"
    },
    {
      name     = "test_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of test (completeness, accuracy, consistency, validity, uniqueness, timeliness)"
    },
    {
      name     = "test_category"
      type     = "STRING"
      nullable = false
      comment  = "Category of test (table_level, column_level, cross_table, business_rule)"
    },
    {
      name     = "column_name"
      type     = "STRING"
      nullable = true
      comment  = "Column name for column-level tests"
    },
    {
      name     = "test_description"
      type     = "STRING"
      nullable = true
      comment  = "Description of what the test validates"
    },
    {
      name     = "test_condition"
      type     = "STRING"
      nullable = false
      comment  = "SQL condition or rule being tested"
    },
    {
      name     = "executed_at"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when test was executed"
    },
    {
      name     = "test_result"
      type     = "STRING"
      nullable = false
      comment  = "Result of the test (pass, fail, warning, error)"
    },
    {
      name     = "records_tested"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records included in the test"
    },
    {
      name     = "records_passed"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records that passed the test"
    },
    {
      name     = "records_failed"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of records that failed the test"
    },
    {
      name     = "pass_rate_percent"
      type     = "DOUBLE"
      nullable = true
      comment  = "Percentage of records that passed the test"
    },
    {
      name     = "expected_value"
      type     = "STRING"
      nullable = true
      comment  = "Expected value or range for the test"
    },
    {
      name     = "actual_value"
      type     = "STRING"
      nullable = true
      comment  = "Actual value measured by the test"
    },
    {
      name     = "threshold_value"
      type     = "DOUBLE"
      nullable = true
      comment  = "Threshold value for pass/fail determination"
    },
    {
      name     = "threshold_operator"
      type     = "STRING"
      nullable = true
      comment  = "Comparison operator for threshold (gt, lt, gte, lte, eq, ne)"
    },
    {
      name     = "is_critical"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this is a critical test that should fail the pipeline"
    },
    {
      name     = "test_duration_seconds"
      type     = "DOUBLE"
      nullable = true
      comment  = "Time taken to execute the test in seconds"
    },
    {
      name     = "error_message"
      type     = "STRING"
      nullable = true
      comment  = "Error message if test execution failed"
    },
    {
      name     = "test_metadata"
      type     = "STRING"
      nullable = true
      comment  = "Additional test metadata and configuration (JSON)"
    },
    {
      name     = "failed_records_sample"
      type     = "STRING"
      nullable = true
      comment  = "Sample of records that failed the test (JSON array, limited)"
    }
  ]
}