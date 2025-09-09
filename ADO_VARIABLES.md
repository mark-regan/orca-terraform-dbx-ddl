# Azure DevOps Variable Groups Configuration

This document outlines the required Azure DevOps variable groups for deploying the ORCA DDL tables via Terraform.

## Required Variable Groups

### Common Variables (databricks-common)
This group should already exist and contain:
- `DATABRICKS_WORKSPACE_URL`: The Databricks workspace URL
- `TF_STATE_RESOURCE_GROUP`: Resource group for Terraform state
- `TF_STATE_STORAGE_ACCOUNT`: Storage account for Terraform state
- `TF_STATE_CONTAINER`: Container name for Terraform state

### Environment-Specific Variable Groups

Create the following variable groups in Azure DevOps for each environment:

#### 1. orca-ddl-dev-vars
```yaml
ORCA_CATALOG_NAME: dev_catalog        # Replace with your actual dev catalog name
ORCA_METADATA_SCHEMA_NAME: orca_metadata
ORCA_RUNTIME_SCHEMA_NAME: orca_runtime
```

#### 2. orca-ddl-test-vars
```yaml
ORCA_CATALOG_NAME: test_catalog       # Replace with your actual test catalog name
ORCA_METADATA_SCHEMA_NAME: orca_metadata
ORCA_RUNTIME_SCHEMA_NAME: orca_runtime
```

#### 3. orca-ddl-uat-vars
```yaml
ORCA_CATALOG_NAME: uat_catalog        # Replace with your actual UAT catalog name
ORCA_METADATA_SCHEMA_NAME: orca_metadata
ORCA_RUNTIME_SCHEMA_NAME: orca_runtime
```

#### 4. orca-ddl-prod-vars
```yaml
ORCA_CATALOG_NAME: prod_catalog       # Replace with your actual prod catalog name
ORCA_METADATA_SCHEMA_NAME: orca_metadata
ORCA_RUNTIME_SCHEMA_NAME: orca_runtime
```

## How to Create Variable Groups in Azure DevOps

1. Navigate to your Azure DevOps project
2. Go to **Pipelines** → **Library**
3. Click **+ Variable group**
4. Enter the group name (e.g., `orca-ddl-dev-vars`)
5. Add the variables listed above with appropriate values for your environment
6. Click **Save**

## Customizing Schema Names

If you need different schema names per environment, you can modify the variables:

```yaml
# For example, to include environment prefix in schema names:
ORCA_METADATA_SCHEMA_NAME: dev_orca_metadata
ORCA_RUNTIME_SCHEMA_NAME: dev_orca_runtime
```

## Using the Variables in Pipeline

The pipeline automatically references these variables:

```yaml
variables:
  - group: databricks-dev-vars      # Existing Databricks configuration
  - group: orca-ddl-dev-vars        # ORCA-specific configuration
```

The Terraform deployment uses these variables:

```hcl
terraform plan \
  -var="catalog_name=$(ORCA_CATALOG_NAME)" \
  -var="metadata_schema_name=$(ORCA_METADATA_SCHEMA_NAME)" \
  -var="runtime_schema_name=$(ORCA_RUNTIME_SCHEMA_NAME)"
```

## Security Considerations

- Mark sensitive variables as **secret** in Azure DevOps
- Use service connections with appropriate permissions
- Ensure the service principal has necessary Databricks permissions to create catalogs, schemas, and tables

## Validation

Before running the pipeline, ensure:

1. All variable groups are created
2. Service connections have proper permissions
3. The Unity Catalog exists in your Databricks workspace
4. The service principal has CREATE SCHEMA and CREATE TABLE permissions on the catalog