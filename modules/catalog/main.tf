resource "databricks_catalog" "this" {
  name            = var.name
  comment         = var.comment
  storage_root    = var.storage_root
  provider_name   = var.provider_name
  share_name      = var.share_name
  connection_name = var.connection_name
  
  properties    = var.properties
  force_destroy = var.force_destroy
  owner         = var.owner
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "databricks_grants" "this" {
  count = length(var.grants) > 0 ? 1 : 0

  catalog = databricks_catalog.this.name

  dynamic "grant" {
    for_each = var.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_catalog.this]
}

resource "databricks_schema" "schemas" {
  for_each = var.schemas

  catalog_name = databricks_catalog.this.name
  name         = each.key
  comment      = each.value.comment
  properties   = each.value.properties
  owner        = each.value.owner
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
  
  force_destroy = each.value.force_destroy

  depends_on = [databricks_catalog.this]
}

resource "databricks_grants" "schema_grants" {
  for_each = {
    for schema_name, schema in var.schemas : schema_name => schema
    if length(schema.grants) > 0
  }

  schema = "${databricks_catalog.this.name}.${each.key}"

  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_schema.schemas]
}