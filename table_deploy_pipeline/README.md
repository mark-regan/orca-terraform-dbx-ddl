Overview

This pipeline executes ordered DDL/DML SQL files against your Azure Databricks workspace using Azure DevOps with Workload Identity Federation (OIDC). It authenticates via Azure CLI, acquires an AAD access token for Databricks, and submits statements to a SQL Warehouse using the Databricks SQL Statement Execution API.

Key features
- Uses existing ADO variable groups in this repo: dbx-<env>-vars, dbx-unity-<env>-vars, dbx-azure-<env>-vars, dbx-common
- OIDC-based auth (no PATs) via the configured service connection
- Environment-separated SQL folders with an optional common folder
- Deterministic execution order based on filename (lexicographic)
- Warehouse selection by ID or by name
- Inline variable templating in SQL using ${VAR_NAME} from ADO variable groups
- File tagging with -- tags: ... and selective execution by tag
- Captures per-file execution results and publishes as artifacts (JSONL + summary)

Repo layout
- table_deploy_pipeline/
  - azure-pipelines.yml: main ADO pipeline definition
  - README.md: this documentation
  - sql/
    - common/: SQL scripts applied to all environments (optional)
    - dev/: environment-specific SQL
    - test/: environment-specific SQL
    - uat/: environment-specific SQL
    - prod/: environment-specific SQL

Requirements
- Azure DevOps service connection configured with Workload Identity Federation to your Azure tenant
- The service principal added to the Databricks workspace and granted required privileges for running the SQL (e.g., USE_CATALOG/CREATE/ALTER on UC objects as needed)
- A running Databricks SQL Warehouse for execution

Variable groups
The pipeline uses the same variable groups as the Terraform pipelines in this repo. Ensure these exist and contain, at minimum:
- dbx-common
  - databricks_host: your Databricks workspace URL, e.g. https://adb-<id>.<region>.azuredatabricks.net
- dbx-<env>-vars, dbx-unity-<env>-vars, dbx-azure-<env>-vars (for each environment)
  - Option A (preferred): databricks_sql_warehouse_id: the Warehouse ID
  - Option B: databricks_sql_warehouse_name: the Warehouse Name (the pipeline will resolve to ID)

Variable templating
- Use ${VAR_NAME} placeholders inside your .sql files. At runtime, these are replaced using environment variables exposed by ADO variable groups.
- Mapping rule: ADO variable 'var_name' becomes environment variable 'VAR_NAME'. Example mappings:
  - catalog_orca -> ${CATALOG_ORCA}
  - schema_orca_metadata -> ${SCHEMA_ORCA_METADATA}
  - schema_orca_runtime -> ${SCHEMA_ORCA_RUNTIME}
- Only variables present in a file are substituted. Unset variables result in empty strings; ensure required vars are defined in the variable groups for the target environment.

Example with templating
-- table_deploy_pipeline/sql/dev/010_create_schema.sql
-- tags: ddl,schemas
USE CATALOG ${CATALOG_ORCA};
CREATE SCHEMA IF NOT EXISTS ${SCHEMA_ORCA_METADATA};

-- table_deploy_pipeline/sql/dev/020_create_table.sql
-- tags: ddl,tables
USE CATALOG ${CATALOG_ORCA};
USE SCHEMA ${SCHEMA_ORCA_METADATA};
CREATE TABLE IF NOT EXISTS ${SCHEMA_ORCA_METADATA}.job_runs (
  job_id BIGINT,
  name STRING
);

Note: If neither warehouse id nor name is defined for the environment, you can override it at queue time with the pipeline parameter warehouseIdOverride.

SQL structure and ordering
- Place common scripts in table_deploy_pipeline/sql/common (executed first)
- Place environment scripts in table_deploy_pipeline/sql/<env> (executed after common)
- Files are executed in lexicographical order; use numeric prefixes for ordering, e.g.:
  - 001_create_catalogs.sql
  - 010_create_schemas.sql
  - 100_create_tables.sql
  - 200_seed_data.sql

Tagging and selective execution
- Add a header line with tags in each file that you want to selectively run:
  -- tags: ddl,seed,hotfix
- Run the pipeline with parameter tags set to a comma-separated list to include only files that have at least one of those tags. Examples:
  - Run only DDL: set tags = "ddl"
  - Run only hotfixes: set tags = "hotfix"
  - Run DDL and seed: set tags = "ddl,seed"
- If tags parameter is empty, all files are considered (no tag filtering).

Authentication details
- The pipeline logs into Azure via OIDC with AzureCLI@2 using your service connection
- It acquires an AAD access token for resource https://databricks.azure.net/
- All REST calls to Databricks pass the Bearer token; no PAT is required

Permissions
- The service principal must be present in the Databricks workspace (SCIM) and have permissions required by your SQL (e.g., Metastore/Catalog/Schema/Table privileges)
- If your SQL creates or alters Unity Catalog objects, ensure the principal has CREATE/ALTER/USAGE privileges at the appropriate scopes

Triggers and environments
- develop and feature/* branches -> Dev stage
- release/* branches -> Test and then UAT stages
- main branch -> Prod stage

Parameters
- sqlPath (default: table_deploy_pipeline/sql): root path to SQL files
- warehouseIdOverride (default: empty): explicit warehouse id to use; takes precedence over variable groups
- tags (default: empty): comma-separated list of tags to include; only files with at least one matching tag will run

How it works
1) AzureCLI@2 obtains OIDC variables and logs in to Azure
2) A Bash step acquires the AAD token for Databricks and determines the Warehouse ID
3) The step discovers .sql files in common then environment folders and filters by tags if provided
4) Each file is rendered by substituting ${VAR_NAME} with ADO variable values (env vars) using envsubst
5) The rendered statement is submitted to the Databricks SQL Statement Execution API and polled until SUCCEEDED or FAILED

Usage
1) Commit your SQL files under table_deploy_pipeline/sql/common and table_deploy_pipeline/sql/<env>
2) Ensure variable groups contain databricks_host and a warehouse id or name for each environment
3) Create a new Pipeline in Azure DevOps pointing to table_deploy_pipeline/azure-pipelines.yml
4) (Optional) Override parameters at queue time:
   - sqlPath: alternative folder to execute
   - warehouseIdOverride: explicit warehouse id
   - tags: comma-separated tags to include

Example SQL
Use fully qualified names or explicit USE statements to control context:

-- table_deploy_pipeline/sql/dev/001_create_schema.sql
-- Ensure we are using the intended catalog and schema
USE CATALOG my_dev_catalog;
CREATE SCHEMA IF NOT EXISTS my_schema;

-- table_deploy_pipeline/sql/dev/100_create_table.sql
USE CATALOG my_dev_catalog;
USE SCHEMA my_schema;
CREATE TABLE IF NOT EXISTS my_table (id BIGINT, name STRING);

Results and artifacts
- After execution, per-environment results are saved under: `$(Build.ArtifactStagingDirectory)/sql-results/<env>/`
- Files produced:
  - `result.jsonl`: one JSON object per executed file with fields: file, status, statement_id, start_epoch_s, end_epoch_s, duration_s, tags[], error (optional)
  - `summary.json`: simple aggregate with counts { ran, failures }
- The pipeline publishes these directories as artifacts: `sql-results-dev`, `sql-results-test`, `sql-results-uat`, `sql-results-prod`

Example result.jsonl entry
{"file":"table_deploy_pipeline/sql/dev/020_create_table.sql","status":"SUCCEEDED","statement_id":"01abc...","start_epoch_s":1694371200,"end_epoch_s":1694371203,"duration_s":3,"tags":["ddl","tables"]}


Troubleshooting
- 401/403 from Databricks API: ensure the service principal is added to the workspace and has required UC privileges
- Warehouse not found: set databricks_sql_warehouse_id or databricks_sql_warehouse_name in variable groups, or use warehouseIdOverride
- Network/firewall issues: if the workspace enforces IP access lists, ensure ADO agent IPs or a self-hosted agent is allowed
-
  If statements fail with dependencies, ensure ordering via filename prefixes and that earlier DDL commits before dependent statements

Notes on templating
- Variables are case-sensitive in SQL placeholders: use uppercase ${VAR_NAME}
- Only A-Z, 0-9 and underscores are supported in variable names
- If a variable isn’t defined, it substitutes to empty; validate with a pre-flight SQL or add a guard in your scripts

Extending
- Add pre/post steps (e.g., dry-run validation) by adding additional Bash tasks
- Add a second job to capture results/logs as artifacts if needed
