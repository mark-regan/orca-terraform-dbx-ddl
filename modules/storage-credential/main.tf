resource "databricks_storage_credential" "this" {
  name    = var.name
  comment = var.comment

  azure_managed_identity {
    access_connector_id = var.access_connector_id
  }

  force_destroy = var.force_destroy
  owner         = var.owner

  lifecycle {
    prevent_destroy = var.prevent_destroy
    ignore_changes  = var.ignore_changes_list
  }
}

resource "databricks_grants" "this" {
  count = length(var.grants) > 0 ? 1 : 0

  storage_credential = databricks_storage_credential.this.id

  dynamic "grant" {
    for_each = var.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_storage_credential.this]
}