module "example_raw_table" {
  source = "../../../../modules/delta-table"
  
  catalog_name   = module.catalogs["bronze"].name
  schema_name    = "raw_ingestion"
  table_name     = "example_raw_data"
  table_comment  = "Example raw data ingestion table"
  enable_cdf     = true
  
  columns = [
    {
      name     = "record_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique record identifier"
    },
    {
      name     = "source_system"
      type     = "STRING"
      nullable = false
      comment  = "Source system name"
    },
    {
      name     = "raw_data"
      type     = "STRING"
      nullable = true
      comment  = "Raw JSON data"
    },
    {
      name     = "ingestion_timestamp"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when data was ingested"
    },
    {
      name     = "file_name"
      type     = "STRING"
      nullable = true
      comment  = "Source file name"
    },
    {
      name     = "batch_id"
      type     = "STRING"
      nullable = false
      comment  = "Batch identifier for tracking"
    }
  ]
  
  grants = [
    {
      principal  = "data_engineers"
      privileges = ["SELECT", "MODIFY"]
    }
  ]
}