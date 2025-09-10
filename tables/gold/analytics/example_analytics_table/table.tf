module "example_analytics_table" {
  source = "../../../../modules/delta-table"
  
  catalog_name   = module.catalogs["gold"].name
  schema_name    = "analytics"
  table_name     = "example_business_metrics"
  table_comment  = "Example business metrics aggregation"
  enable_cdf     = false
  primary_key    = ["metric_date", "business_unit"]
  
  columns = [
    {
      name     = "metric_date"
      type     = "DATE"
      nullable = false
      comment  = "Date of the metric"
    },
    {
      name     = "business_unit"
      type     = "STRING"
      nullable = false
      comment  = "Business unit identifier"
    },
    {
      name     = "total_revenue"
      type     = "DECIMAL(18,2)"
      nullable = true
      comment  = "Total revenue for the period"
    },
    {
      name     = "total_transactions"
      type     = "BIGINT"
      nullable = true
      comment  = "Total number of transactions"
    },
    {
      name     = "average_transaction_value"
      type     = "DECIMAL(10,2)"
      nullable = true
      comment  = "Average transaction value"
    },
    {
      name     = "customer_count"
      type     = "BIGINT"
      nullable = true
      comment  = "Number of unique customers"
    },
    {
      name     = "growth_rate"
      type     = "DECIMAL(5,2)"
      nullable = true
      comment  = "Growth rate percentage"
    },
    {
      name     = "calculated_timestamp"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "When metrics were calculated"
    }
  ]
  
  grants = [
    {
      principal  = "data_engineers"
      privileges = ["SELECT", "MODIFY"]
    },
    {
      principal  = "business_users"
      privileges = ["SELECT"]
    }
  ]
}