# Extended Databricks Unity Catalog Infrastructure

This repository has been extended to support comprehensive Unity Catalog management including storage credentials, external locations, catalogs, schemas, and tables with fine-grained access control.

## New Features

### 1. Storage Credentials
- Azure managed identity support
- Modular configuration in `storage-credentials.tf`
- Grant-based access control
- Environment-specific naming

### 2. External Locations
- Hierarchical data lake structure (Bronze/Silver/Gold)
- Read-only location support
- Fine-grained access grants
- Integration with storage credentials

### 3. Catalogs with Schemas
- Multi-catalog support (ORCA, Bronze, Silver, Gold)
- Schema management within catalogs
- Catalog and schema-level grants
- Storage root configuration per catalog

### 4. Enhanced Table Management
- Multi-catalog table deployment
- Table-level grant support
- Backward compatibility with existing ORCA tables
- Example tables for each data layer

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Storage Credentials                    │
│  (Azure Managed Identities for each data layer)          │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                   External Locations                      │
│  (Bronze Raw, Silver Cleansed, Gold Analytics, etc.)     │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│                       Catalogs                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │   ORCA   │ │  Bronze  │ │  Silver  │ │   Gold   │   │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘   │
│       │            │            │            │           │
│   Schemas      Schemas      Schemas      Schemas        │
│   └Tables      └Tables      └Tables      └Tables        │
└──────────────────────────────────────────────────────────┘
```

## Module Structure

### Storage Credential Module (`modules/storage-credential/`)
```hcl
module "storage_credentials" {
  source = "./modules/storage-credential"
  
  name                = "credential_name"
  access_connector_id = "azure_access_connector_resource_id"
  grants = [{
    principal  = "group_or_user"
    privileges = ["CREATE_EXTERNAL_LOCATION"]
  }]
}
```

### External Location Module (`modules/external-location/`)
```hcl
module "external_locations" {
  source = "./modules/external-location"
  
  name            = "location_name"
  url             = "abfss://container@storage.dfs.core.windows.net/path"
  credential_name = "storage_credential_name"
  grants = [{
    principal  = "group_or_user"
    privileges = ["READ_FILES", "WRITE_FILES"]
  }]
}
```

### Catalog Module (`modules/catalog/`)
```hcl
module "catalogs" {
  source = "./modules/catalog"
  
  name         = "catalog_name"
  storage_root = "abfss://container@storage.dfs.core.windows.net/managed"
  grants = [{
    principal  = "group_or_user"
    privileges = ["USE_CATALOG", "CREATE_SCHEMA"]
  }]
  schemas = {
    schema_name = {
      comment = "Schema description"
      grants = [{
        principal  = "group_or_user"
        privileges = ["USE_SCHEMA", "CREATE_TABLE"]
      }]
    }
  }
}
```

## Configuration Files

### Storage Credentials (`storage-credentials.tf`)
Defines all storage credentials with Azure managed identity configuration.

### External Locations (`external-locations.tf`)
Defines external locations for different data layers with appropriate access controls.

### Catalogs (`catalogs.tf`)
Defines catalogs and their schemas with comprehensive grant configurations.

### Tables (`tables.tf`)
Dynamic table loader that scans the `tables/` directory structure.

## Grant System

The grant system supports fine-grained access control at multiple levels:

### Storage Credential Grants
- `CREATE_EXTERNAL_LOCATION`: Allow creation of external locations

### External Location Grants
- `READ_FILES`: Read access to files
- `WRITE_FILES`: Write access to files
- `CREATE_EXTERNAL_TABLE`: Create external tables

### Catalog Grants
- `USE_CATALOG`: Basic catalog access
- `CREATE_SCHEMA`: Create schemas in catalog
- `CREATE_TABLE`: Create tables in catalog
- `CREATE_FUNCTION`: Create functions in catalog

### Schema Grants
- `USE_SCHEMA`: Basic schema access
- `CREATE_TABLE`: Create tables in schema
- `CREATE_VIEW`: Create views in schema
- `CREATE_FUNCTION`: Create functions in schema
- `MODIFY`: Modify existing objects

### Table Grants
- `SELECT`: Read data
- `MODIFY`: Insert, update, delete data
- `ALL_PRIVILEGES`: Full access

## Environment Configuration

Update your environment-specific `.tfvars` files:

```hcl
# Environment
environment = "dev"

# Storage Configuration
storage_account_name = "devdatalake"

# Access Connectors for Managed Identities
bronze_access_connector_id = "/subscriptions/.../accessConnectors/bronze"
silver_access_connector_id = "/subscriptions/.../accessConnectors/silver"
gold_access_connector_id   = "/subscriptions/.../accessConnectors/gold"

# ORCA Configuration (backward compatibility)
catalog_name = "dev_catalog"
```

## Data Layer Structure

### Bronze Layer (Raw Data)
- **Catalog**: `{env}_bronze_catalog`
- **Schemas**: `raw_ingestion`, `staging`
- **Purpose**: Raw data landing and staging

### Silver Layer (Cleansed Data)
- **Catalog**: `{env}_silver_catalog`
- **Schemas**: `cleansed`, `enriched`
- **Purpose**: Validated and standardized data

### Gold Layer (Business-Ready)
- **Catalog**: `{env}_gold_catalog`
- **Schemas**: `analytics`, `reporting`, `ml_features`
- **Purpose**: Aggregated business metrics and ML features

### ORCA Platform
- **Catalog**: `{env}_orca_catalog`
- **Schemas**: `orca_metadata`, `orca_runtime`
- **Purpose**: Platform metadata and runtime tracking

## Adding New Resources

### New Storage Credential
1. Add configuration to `storage-credentials.tf`
2. Reference the Azure Access Connector ID
3. Define appropriate grants

### New External Location
1. Add configuration to `external-locations.tf`
2. Reference the storage credential
3. Specify the Azure storage URL
4. Define access grants

### New Catalog
1. Add configuration to `catalogs.tf`
2. Define schemas within the catalog
3. Set catalog and schema-level grants
4. Specify storage root for managed tables

### New Table
1. Create directory: `tables/{catalog}/{schema}/{table_name}/`
2. Create `table.tf` using the delta-table module
3. Define columns, grants, and properties
4. Tables are automatically discovered and deployed

## Security Best Practices

1. **Principle of Least Privilege**: Grant minimum required permissions
2. **Group-Based Access**: Use groups instead of individual users
3. **Environment Separation**: Different credentials per environment
4. **Read-Only Locations**: Use for archived or reference data
5. **Audit Grants**: Regularly review and audit access grants

## Migration from Existing Structure

The new structure maintains backward compatibility:
- Existing ORCA tables continue to work
- `catalog_name` variable defaults to empty string
- When empty, new catalog features are used
- When set, legacy mode is maintained

## Deployment

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file="environments/dev/terraform.tfvars"

# Apply changes
terraform apply -var-file="environments/dev/terraform.tfvars"
```

## Dependencies

- Terraform >= 1.0
- Databricks Provider >= 1.38.0
- Azure Access Connectors configured
- Unity Catalog enabled workspace
- Appropriate Azure permissions