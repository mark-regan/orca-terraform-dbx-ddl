resource "databricks_external_location" "this" {
  name            = var.name
  url             = var.url
  credential_name = var.credential_name
  comment         = var.comment
  
  skip_validation = var.skip_validation
  read_only       = var.read_only
  force_destroy   = var.force_destroy
  owner           = var.owner
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "databricks_grants" "this" {
  count = length(var.grants) > 0 ? 1 : 0

  external_location = databricks_external_location.this.id

  dynamic "grant" {
    for_each = var.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_external_location.this]
}