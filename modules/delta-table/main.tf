terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.38.0"
    }
  }
}

resource "databricks_sql_table" "this" {
  catalog_name = var.catalog_name
  schema_name  = var.schema_name
  name         = var.table_name
  table_type   = "MANAGED"
  data_source_format = "DELTA"
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
  
  comment = var.table_comment

  dynamic "column" {
    for_each = var.columns
    content {
      name     = column.value.name
      type     = column.value.type
      nullable = lookup(column.value, "nullable", true)
      comment  = lookup(column.value, "comment", null)
    }
  }

  properties = merge(
    {
      "delta.enableChangeDataFeed" = var.enable_cdf
      "delta.autoOptimize.optimizeWrite" = var.enable_auto_optimize
      "delta.autoOptimize.autoCompact" = var.enable_auto_compact
    },
    var.table_properties
  )
}

resource "databricks_grants" "this" {
  count = length(var.grants) > 0 ? 1 : 0
  
  table = "${var.catalog_name}.${var.schema_name}.${var.table_name}"

  dynamic "grant" {
    for_each = var.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_sql_table.this]
}