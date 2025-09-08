# ORCA Terraform Databricks DDL

This repository contains Terraform configurations for managing Databricks table definitions, views, and initial data loading.

## Repository Structure

```
.
├── deployments/                     # Deployment manifests
│   └── table-deployment-manifest.json
├── tables/                          # Table definitions organized by catalog/schema
│   ├── orca_catalog/
│   │   ├── orca_metadata_v1/
│   │   │   ├── feed_metadata/
│   │   │   │   ├── table.tf
│   │   │   │   ├── variables.tf
│   │   │   │   └── initial_data.tf
│   │   │   └── feed_step_metadata/
│   │   └── orca_runtime_v1/
│   ├── bronze_catalog/
│   │   ├── bancs_v1/
│   │   └── digihome_v1/
│   ├── silver_catalog/
│   │   └── datawarehouse_v1/
│   ├── gold_catalog/
│   │   ├── customer_v1/
│   │   └── account_v1/
│   └── platinum_catalog/
├── views/                           # View definitions
│   └── gold_catalog/
│       └── reporting_v1/
├── functions/                       # UDF definitions
│   └── silver_catalog/
│       └── utilities_v1/
├── modules/                         # Reusable Terraform modules
│   ├── delta-table/
│   ├── view/
│   └── function/
├── environments/                    # Environment-specific configurations
│   ├── dev/
│   ├── test/
│   ├── uat/
│   └── prod/
├── scripts/                         # Utility scripts
│   ├── deploy-tables.sh
│   ├── validate-ddl.sh
│   └── generate-table.sh
└── azure-pipelines/                # Azure DevOps pipeline definitions
    ├── ddl-deploy.yml
    └── templates/
```

## Table Definition Structure

Each table is defined in its own folder with the following structure:
- `table.tf`: Table schema definition
- `variables.tf`: Input variables for the table
- `initial_data.tf`: Optional initial data loading
- `grants.tf`: Optional table-specific permissions

## Deployment Manifest

The `deployments/table-deployment-manifest.json` controls which tables are deployed per environment:

```json
{
  "environment_deployments": {
    "dev": {
      "deploy_all": false,
      "tables_to_deploy": [
        "orca_catalog/orca_metadata_v1/feed_metadata",
        "bronze_catalog/bancs_v1/customer_master"
      ],
      "skip_initial_data": false
    }
  }
}
```

## Prerequisites

- Terraform >= 1.0
- Databricks Provider >= 1.38.0
- Azure CLI
- Databricks CLI
- Unity Catalog enabled workspace

## Usage

### Local Development

1. Navigate to environment directory:
```bash
cd environments/dev
```

2. Initialize Terraform:
```bash
terraform init
```

3. Plan deployment:
```bash
terraform plan -var-file="terraform.tfvars"
```

4. Apply changes:
```bash
terraform apply -var-file="terraform.tfvars"
```

### Adding a New Table

Use the table generator script:
```bash
./scripts/generate-table.sh \
  --catalog bronze_catalog \
  --schema new_schema_v1 \
  --table new_table_name
```

This creates the folder structure and template files.

### CI/CD Pipeline

The repository includes Azure DevOps pipelines for automated deployment:

- Triggered on push to main/develop branches
- Validates all table definitions
- Deploys only specified tables from manifest
- Supports rollback on failure

## Table Definition Best Practices

1. **Naming Conventions**:
   - Tables: lowercase with underscores
   - Schemas: include version suffix (e.g., `_v1`)
   - Catalogs: end with `_catalog`

2. **Partitioning**:
   - Use date-based partitioning for large tables
   - Partition by ingestion_date for bronze layer
   - Partition by business date for silver/gold layers

3. **Properties**:
   - Always enable Change Data Feed for audit tables
   - Enable auto-optimize for frequently queried tables
   - Set appropriate retention periods

4. **Documentation**:
   - Always include column comments
   - Document table purpose in table comment
   - Include data source information

## Environment Configuration

Each environment has:
- `terraform.tfvars`: Environment-specific variables
- `backend.tfvars`: Terraform state configuration
- `deployment-override.json`: Optional deployment manifest override

## Branching Strategy

- `main`: Production deployments
- `release/*`: UAT deployments
- `develop`: Development deployments
- `feature/*`: Feature development
- `hotfix/*`: Emergency fixes

## Testing

Before deployment:
1. Validate Terraform syntax: `terraform validate`
2. Check formatting: `terraform fmt -check`
3. Review plan output carefully
4. Test in dev environment first

## Security

- No credentials in code
- Use Azure Key Vault for secrets
- Apply principle of least privilege
- Enable table-level audit logging
- Implement column-level security where needed

## Rollback Procedure

1. Revert git commit
2. Run pipeline with previous version
3. Or use Terraform state rollback:
```bash
terraform state pull > backup.tfstate
terraform apply -target=module.table_name -replace=module.table_name
```

## Support

For issues or questions, please create an issue in this repository.