# Storage Credentials Configuration
# Define all storage credentials for accessing Azure storage
# These resources are created once and then tracked in state

locals {
  storage_credentials = {
    # Terraform storage credential
    tf_storage = {
      name                = "${var.environment}_storage_credential_tf"
      comment             = "Storage credential for Bronze layer data - created by Terraform"
      access_connector_id = var.storage_connector_id
      prevent_destroy     = true  # Prevent accidental deletion
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["READ_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["READ_FILES","WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["READ_FILES", "WRITE_FILES"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
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
  access_connector_id = each.value.storage_connector_id
  grants              = lookup(each.value, "grants", [])
  owner               = lookup(each.value, "owner", null)
  force_destroy       = lookup(each.value, "force_destroy", false)
  prevent_destroy     = lookup(each.value, "prevent_destroy", true)
  
  # Ignore changes to prevent updates after initial creation
  ignore_changes_list = lookup(each.value, "ignore_changes_list", [])
}