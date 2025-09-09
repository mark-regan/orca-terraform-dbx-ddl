module "holiday_calendar_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.metadata_schema_name
  table_name     = "holiday_calendar"
  table_comment  = "UK bank holiday definitions - contains calendar of holidays affecting feed scheduling and processing"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["holiday_date", "region"]

  columns = [
    {
      name     = "holiday_date"
      type     = "DATE"
      nullable = false
      comment  = "Date of the holiday"
    },
    {
      name     = "holiday_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of the holiday"
    },
    {
      name     = "region"
      type     = "STRING"
      nullable = false
      comment  = "Geographic region for holiday (UK, England, Scotland, Wales, Northern Ireland)"
    },
    {
      name     = "holiday_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of holiday (bank_holiday, public_holiday, observance)"
    },
    {
      name     = "is_business_day_impact"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this holiday affects business day calculations"
    },
    {
      name     = "affects_processing"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether feed processing is affected by this holiday"
    },
    {
      name     = "alternative_processing_date"
      type     = "DATE"
      nullable = true
      comment  = "Alternative date for processing if holiday affects normal schedule"
    },
    {
      name     = "holiday_description"
      type     = "STRING"
      nullable = true
      comment  = "Description or notes about the holiday"
    },
    {
      name     = "year"
      type     = "INTEGER"
      nullable = false
      comment  = "Year of the holiday for partitioning"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this holiday entry was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User or system that created this holiday entry"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this holiday entry was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this holiday entry"
    }
  ]
}