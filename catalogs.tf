# Catalogs Configuration
# Define all catalogs and their schemas with grant support
# These resources are created once and then tracked in state

locals {
  catalogs = {
    # ORCA Catalog - Main catalog for ORCA platform
    orca = {
      name         = "${var.environment}_orca_catalog"
      comment      = "ORCA Platform Data Catalog"
      storage_root = "abfss://orca@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "orca_service"
          privileges = ["USE_CATALOG", "CREATE_SCHEMA"]
        },
        {
          principal  = "data_engineers"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        orca_metadata = {
          comment = "ORCA Metadata Schema - Configuration and Definitions"
          grants = [
            {
              principal  = "orca_service"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION"]
            },
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "SELECT"]
            }
          ]
        }
        
        orca_runtime = {
          comment = "ORCA Runtime Schema - Execution Tracking and Monitoring"
          grants = [
            {
              principal  = "orca_service"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "MODIFY"]
            },
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "SELECT"]
            }
          ]
        }
      }
    }

    # Bronze Catalog - Raw data layer
    bronze = {
      name         = "${var.environment}_bronze_catalog"
      comment      = "Bronze Layer - Raw Data"
      storage_root = "abfss://bronze@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["USE_CATALOG", "CREATE_SCHEMA"]
        },
        {
          principal  = "data_scientists"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        raw_ingestion = {
          comment = "Raw data ingestion schema"
          grants = [
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "MODIFY"]
            }
          ]
        }
        
        staging = {
          comment = "Staging area for raw data"
          grants = [
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "MODIFY"]
            }
          ]
        }
      }
    }

    # Silver Catalog - Cleansed data layer
    silver = {
      name         = "${var.environment}_silver_catalog"
      comment      = "Silver Layer - Cleansed and Validated Data"
      storage_root = "abfss://silver@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["USE_CATALOG", "CREATE_SCHEMA"]
        },
        {
          principal  = "data_analysts"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        cleansed = {
          comment = "Cleansed and standardized data"
          grants = [
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "MODIFY"]
            },
            {
              principal  = "data_analysts"
              privileges = ["USE_SCHEMA", "SELECT"]
            }
          ]
        }
        
        enriched = {
          comment = "Enriched data with business logic"
          grants = [
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "MODIFY"]
            },
            {
              principal  = "data_analysts"
              privileges = ["USE_SCHEMA", "SELECT"]
            }
          ]
        }
      }
    }

    # Gold Catalog - Business-ready data layer
    gold = {
      name         = "${var.environment}_gold_catalog"
      comment      = "Gold Layer - Business-Ready Analytics"
      storage_root = "abfss://gold@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "data_engineers"
          privileges = ["USE_CATALOG", "CREATE_SCHEMA"]
        },
        {
          principal  = "business_users"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        analytics = {
          comment = "Analytical datasets and aggregations"
          grants = [
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "MODIFY"]
            },
            {
              principal  = "business_users"
              privileges = ["USE_SCHEMA", "SELECT"]
            }
          ]
        }
        
        reporting = {
          comment = "Reporting marts and views"
          grants = [
            {
              principal  = "data_engineers"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_VIEW", "MODIFY"]
            },
            {
              principal  = "business_users"
              privileges = ["USE_SCHEMA", "SELECT"]
            }
          ]
        }
        
        ml_features = {
          comment = "Machine learning feature store"
          grants = [
            {
              principal  = "data_scientists"
              privileges = ["USE_SCHEMA", "CREATE_TABLE", "MODIFY"]
            },
            {
              principal  = "ml_engineers"
              privileges = ["USE_SCHEMA", "SELECT"]
            }
          ]
        }
      }
    }
  }
}

# Create catalogs with schemas and grants
# Once created, these are tracked in state and won't be recreated
module "catalogs" {
  for_each = local.catalogs

  source = "./modules/catalog"

  name          = each.value.name
  comment       = each.value.comment
  storage_root  = lookup(each.value, "storage_root", null)
  grants        = lookup(each.value, "grants", [])
  schemas       = lookup(each.value, "schemas", {})
  owner         = lookup(each.value, "owner", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  depends_on = [module.external_locations]
}