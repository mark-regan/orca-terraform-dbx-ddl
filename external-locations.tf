# External Locations Configuration
# Define all external locations for data access
# These resources are created once and then tracked in state

locals {
  external_locations = {
    # Bronze layer locations
    bronze_raw = {
      name            = "${var.environment}_bronze_raw"
      comment         = "Raw data landing zone"
      url             = "abfss://bronze@${var.storage_account_name}.dfs.core.windows.net/raw"
      credential_name = module.storage_credentials["bronze_storage"].name
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "data_scientists"
          privileges = ["READ_FILES"]
        }
      ]
    }

    bronze_archive = {
      name            = "${var.environment}_bronze_archive"
      comment         = "Archived raw data"
      url             = "abfss://bronze@${var.storage_account_name}.dfs.core.windows.net/archive"
      credential_name = module.storage_credentials["bronze_storage"].name
      read_only       = true
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["READ_FILES"]
        }
      ]
    }

    # Silver layer locations
    silver_cleansed = {
      name            = "${var.environment}_silver_cleansed"
      comment         = "Cleansed and validated data"
      url             = "abfss://silver@${var.storage_account_name}.dfs.core.windows.net/cleansed"
      credential_name = module.storage_credentials["silver_storage"].name
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "data_analysts"
          privileges = ["READ_FILES"]
        }
      ]
    }

    # Gold layer locations
    gold_analytics = {
      name            = "${var.environment}_gold_analytics"
      comment         = "Business-ready analytical datasets"
      url             = "abfss://gold@${var.storage_account_name}.dfs.core.windows.net/analytics"
      credential_name = module.storage_credentials["gold_storage"].name
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "business_users"
          privileges = ["READ_FILES"]
        }
      ]
    }

    # ORCA specific location
    orca_data = {
      name            = "${var.environment}_orca_data"
      comment         = "ORCA platform data location"
      url             = "abfss://orca@${var.storage_account_name}.dfs.core.windows.net/data"
      credential_name = module.storage_credentials["bronze_storage"].name
      grants = [
        {
          principal  = "orca_service"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        }
      ]
    }
  }
}

# Create external locations
# Once created, these are tracked in state and won't be recreated
module "external_locations" {
  for_each = local.external_locations

  source = "./modules/external-location"

  name            = each.value.name
  comment         = each.value.comment
  url             = each.value.url
  credential_name = each.value.credential_name
  grants          = lookup(each.value, "grants", [])
  read_only       = lookup(each.value, "read_only", false)
  skip_validation = lookup(each.value, "skip_validation", false)
  owner           = lookup(each.value, "owner", null)
  force_destroy   = lookup(each.value, "force_destroy", false)

  depends_on = [module.storage_credentials]
}