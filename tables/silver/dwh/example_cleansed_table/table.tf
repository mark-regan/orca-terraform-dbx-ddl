module "example_cleansed_table" {
  source = "../../../../modules/delta-table"
  
  catalog_name   = module.catalogs["silver"].name
  schema_name    = "cleansed"
  table_name     = "example_cleansed_data"
  table_comment  = "Example cleansed and validated data"
  enable_cdf     = false
  primary_key    = ["business_key"]
  
  columns = [
    {
      name     = "business_key"
      type     = "STRING"
      nullable = false
      comment  = "Business key for the record"
    },
    {
      name     = "entity_name"
      type     = "STRING"
      nullable = false
      comment  = "Entity name"
    },
    {
      name     = "attribute_1"
      type     = "STRING"
      nullable = true
      comment  = "First business attribute"
    },
    {
      name     = "attribute_2"
      type     = "DOUBLE"
      nullable = true
      comment  = "Second business attribute"
    },
    {
      name     = "valid_from"
      type     = "DATE"
      nullable = false
      comment  = "Start date of validity"
    },
    {
      name     = "valid_to"
      type     = "DATE"
      nullable = true
      comment  = "End date of validity"
    },
    {
      name     = "is_current"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Current record indicator"
    },
    {
      name     = "processed_timestamp"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Processing timestamp"
    }
  ]
  
  grants = [
    {
      principal  = "data_engineers"
      privileges = ["SELECT", "MODIFY"]
    },
    {
      principal  = "data_analysts"
      privileges = ["SELECT"]
    }
  ]
}