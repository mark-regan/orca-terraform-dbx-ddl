-- tags: ddl,tables

CREATE TABLE IF NOT EXISTS ${CATALOG_ORCA}.${SCHEMA_ORCA_METADATA}.example_table3 (
  id BIGINT,
  name STRING
);

GRANT SELECT, MODIFY ON ${CATALOG_ORCA}.${SCHEMA_ORCA_METADATA}.example_table3 to `Azure_MIReporting_Databricks_Orca_Exec_Dev`;
GRANT SELECT, MODIFY ON ${CATALOG_ORCA}.${SCHEMA_ORCA_METADATA}.example_table3 to `Azure_MIReporting_Databricks_Orca_Support_Dev`;
GRANT SELECT, MODIFY ON ${CATALOG_ORCA}.${SCHEMA_ORCA_METADATA}.example_table3 to `Azure_MIReporting_Admin_Dev`;
