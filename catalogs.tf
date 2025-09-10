# Catalogs Configuration
# Define all catalogs and their schemas with grant support
# These resources are created once and then tracked in state

locals {
  catalogs = {
    # ORCA Catalog - Main catalog for ORCA platform
    orca = {
      name         = "${var.orca_catalog}"
      comment      = "ORCA Platform Data Catalog"
      storage_root = "abfss://orchestration@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        },
        {
          principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        orca_metadata = {
          name = "${var.orca_metadata_schema}"
          comment = "ORCA Metadata Schema - Configuration and Definitions"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
        
        orca_runtime = {
          name = "${var.orca_runtime_schema}"
          comment = "ORCA Runtime Schema - Execution Tracking and Monitoring"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
      }
    }

    # Bronze Catalog - Raw data layer
    bronze = {
      name         = "${var.bronze_catalog}"
      comment      = "Bronze Layer - Raw Data"
      storage_root = "abfss://bronze@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        },
        {
          principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        bancs = {
          name = "bancs"
          comment = "BANCS Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        bancs_staging = {
          name = "bancs_staging"
          comment = "BANCS Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        digihome = {
          name = "digihome"
          comment = "Digihome Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        digihome_staging = {
          name = "digihome_staging"
          comment = "Digihome Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        creatio = {
          name = "creatio"
          comment = "Creatio Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        creatio_staging = {
          name = "creatio_staging"
          comment = "Creatio Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        cexperian = {
          name = "experian"
          comment = "Experian Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        experian_staging = {
          name = "experian_staging"
          comment = "Experian Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        enfuce = {
          name = "enfuce"
          comment = "Enfuce Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        enfuce_staging = {
          name = "enfuce_staging"
          comment = "Enfuce Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        moneyfacts = {
          name = "moneyfacts"
          comment = "Moneyfacts Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        moneyfacts_staging = {
          name = "moneyfacts_staging"
          comment = "Moneyfacts Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        caci = {
          name = "caci"
          comment = "CACI Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        caci_staging = {
          name = "caci_staging"
          comment = "CACI Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        external= {
          name = "external"
          comment = "External Auxilliary Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        external_staging = {
          name = "external_staging"
          comment = "External Auxilliary Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        internal= {
          name = "internal"
          comment = "Internal Auxilliary Data - Validated raw data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }

        internal_staging = {
          name = "internal_staging"
          comment = "Internal Auxilliary Data - Initial Raw Data"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Bronze_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
      }
    }

    # Silver Catalog - Cleansed data layer
    silver = {
      name         = "${var.silver_catalog}"
      comment      = "Silver Layer - Cleansed and Validated Data"
      storage_root = "abfss://silver@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Silver_Readonly_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Silver_Readwrite_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        },
        {
          principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        dwh = {
          comment = "Datawarehouse model layer used for reporting and analysis"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Silver_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Silver_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
        
        lakehouse = {
          comment = "Datalakehouse presenting non-modelled data for reporting consumption"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Silver_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Silver_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
      }
    }

    # Gold Catalog - Business-ready data layer
    gold = {
      name         = "${var.gold_catalog}"
      comment      = "Gold Layer - Business-Ready Analytics"
      storage_root = "abfss://gold@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Gold_Readonly_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Gold_Readwrite_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        },
        {
          principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        analytics = {
          comment = "Analytical datasets and aggregations"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Gold_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Gold_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
        
        reporting = {
          comment = "Reporting marts and views"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Gold_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Gold_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
      }
    }

    # Platinum Catalog - Business-ready data layer
    platinum = {
      name         = "${var.platinum_catalog}"
      comment      = "Platinum Layer - Secure aggregates and metrics"
      storage_root = "abfss://platinum@${var.storage_account_name}.dfs.core.windows.net/managed"
      
      grants = [
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Platinum_Readonly_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Databricks_Platinum_Readwrite_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        },
        {
          principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
          privileges = ["ALL_PRIVILEGES"]
        },
        {
          principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
          privileges = ["USE_CATALOG"]
        }
      ]

      schemas = {
        analytics = {
          comment = "Analytical datasets and aggregations"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_PlatinumReadonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Platinum_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            }
          ]
        }
        
        reporting = {
          comment = "Reporting marts and views"
          grants = [
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Support_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Orca_Exec_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Platinum_Readonly_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY"]
            },
            {
              principal  = "Azure_MIReporting_Databricks_Platinum_Readwrite_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT","MODIFY","WRITE_VOLUME","REFRESH","CREATE_TABLE","CREATE_MATERIALIZED_VIEW"]
            },
            {
              principal  = "Azure_MIReporting_Admin_${var.ad_group_environment}"
              privileges = ["ALL_PRIVILEGES"]
            },
            {
              principal  = "Azure_MIReporting_Developer_${var.ad_group_environment}"
              privileges = ["USE_SCHEMA","EXECUTE","READ_VOLUME","SELECT"]
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