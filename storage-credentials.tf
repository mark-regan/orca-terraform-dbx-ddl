# Storage Credentials Configuration
# Define all storage credentials for accessing Azure storage
# These resources are created once and then tracked in state

locals {
  storage_credentials = {
    # Bronze layer storage credential
    bronze_storage = {
      name                = "${var.environment}_bronze_storage_credential"
      comment             = "Storage credential for Bronze layer data"
      access_connector_id = var.bronze_access_connector_id
      prevent_destroy     = true  # Prevent accidental deletion
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["CREATE_EXTERNAL_LOCATION"]
        }
      ]
    }

    # Silver layer storage credential  
    silver_storage = {
      name                = "${var.environment}_silver_storage_credential"
      comment             = "Storage credential for Silver layer data"
      access_connector_id = var.silver_access_connector_id
      prevent_destroy     = true
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["CREATE_EXTERNAL_LOCATION"]
        }
      ]
    }

    # Gold layer storage credential
    gold_storage = {
      name                = "${var.environment}_gold_storage_credential"
      comment             = "Storage credential for Gold layer data"
      access_connector_id = var.gold_access_connector_id
      prevent_destroy     = true
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["CREATE_EXTERNAL_LOCATION"]
        }
      ]
    }
  }
}

# Create storage credentials
# Once created, these are tracked in state and won't be recreated
module "storage_credentials" {
  for_each = local.storage_credentials

  source = "./modules/storage-credential"

  name                = each.value.name
  comment             = each.value.comment
  access_connector_id = each.value.access_connector_id
  grants              = lookup(each.value, "grants", [])
  owner               = lookup(each.value, "owner", null)
  force_destroy       = lookup(each.value, "force_destroy", false)
  prevent_destroy     = lookup(each.value, "prevent_destroy", true)
  
  # Ignore changes to prevent updates after initial creation
  ignore_changes_list = lookup(each.value, "ignore_changes_list", [])
}