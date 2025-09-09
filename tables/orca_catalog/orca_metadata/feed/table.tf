module "feed_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.metadata_schema_name
  table_name     = "feed"
  table_comment  = "Core feed definitions registry - contains master list of all data processing feeds in the ORCA platform"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["feed_id"]

  columns = [
    {
      name     = "feed_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the feed"
    },
    {
      name     = "feed_name"
      type     = "STRING"
      nullable = false
      comment  = "Human-readable name of the feed"
    },
    {
      name     = "feed_description"
      type     = "STRING"
      nullable = true
      comment  = "Detailed description of the feed's purpose and functionality"
    },
    {
      name     = "feed_type"
      type     = "STRING"
      nullable = false
      comment  = "Type of feed (batch, streaming, adhoc)"
    },
    {
      name     = "business_domain"
      type     = "STRING"
      nullable = false
      comment  = "Business domain this feed belongs to (customer, account, transaction, etc.)"
    },
    {
      name     = "data_source"
      type     = "STRING"
      nullable = false
      comment  = "Source system providing the data (bancs, digihome, etc.)"
    },
    {
      name     = "owner_team"
      type     = "STRING"
      nullable = false
      comment  = "Team responsible for maintaining this feed"
    },
    {
      name     = "owner_email"
      type     = "STRING"
      nullable = false
      comment  = "Contact email for the feed owner"
    },
    {
      name     = "is_active"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this feed is currently active"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this feed was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User who created this feed"
    },
    {
      name     = "modified_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this feed was last modified"
    },
    {
      name     = "modified_by"
      type     = "STRING"
      nullable = true
      comment  = "User who last modified this feed"
    }
  ]
}