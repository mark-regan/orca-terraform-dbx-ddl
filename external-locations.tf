# External Locations Configuration
# Define all external locations for data access
# These resources are created once and then tracked in state

locals {
  external_locations = {
    # Bronze layer locations
    bronze = {
      name            = "${var.environment}_bronze_raw_tf"
      comment         = "Raw data landing zone"
      url             = "abfss://bronze@${var.storage_account_name}.dfs.core.windows.net"
      credential_name = module.storage_credentials["tf_storage"].name
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
          privileges = ["READ_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        }
      ]
    }

    # platinum layer locations
    platinum = {
      name            = "${var.environment}_platinum_cleansed_tf"
      comment         = "Aggregated reporting semantic view layer"
      url             = "abfss://platinum@${var.storage_account_name}.dfs.core.windows.net"
      credential_name = module.storage_credentials["tf_storage"].name
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_platinum_Readonly_${var.ad_group_environment}"
          privileges = ["READ_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_platinum_Readwrite_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        }
      ]
    }

    # Platinum layer locations
    platinum = {
      name            = "${var.environment}_platinum_cleansed_tf"
      comment         = "Aggregated reporting semantic view layer"
      url             = "abfss://platinum@${var.storage_account_name}.dfs.core.windows.net"
      credential_name = module.storage_credentials["tf_storage"].name
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_platinum_Readonly_${var.ad_group_environment}"
          privileges = ["READ_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_platinum_Readwrite_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        }
      ]
    }

    # Platinum layer locations
    platinum = {
      name            = "${var.environment}_platinum_cleansed_tf"
      comment         = "Highly aggregated and secured data"
      url             = "abfss://platinum@${var.storage_account_name}.dfs.core.windows.net"
      credential_name = module.storage_credentials["tf_storage"].name
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Platinum_Readonly_${var.ad_group_environment}"
          privileges = ["READ_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Platinum_Readwrite_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        }
      ]
    }

    # ORCA specific location
    orca = {
      name            = "${var.environment}_orca_data_tf"
      comment         = "ORCA platform data location"
      url             = "abfss://orchestration@${var.storage_account_name}.dfs.core.windows.net"
      credential_name = module.storage_credentials["tf_storage"].name
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["CREATE_EXTERNAL_TABLE", "READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
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