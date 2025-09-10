module "code_version_table" {
  source = "../../../../modules/delta-table"

  catalog_name   = var.catalog_name
  schema_name    = var.metadata_schema_name
  table_name     = "code_version"
  table_comment  = "ORCA framework version tracking - maintains version history and deployment information"
  enable_cdf     = var.enable_cdf_for_metadata
  primary_key    = ["version_id"]

  columns = [
    {
      name     = "version_id"
      type     = "STRING"
      nullable = false
      comment  = "Unique identifier for the code version"
    },
    {
      name     = "version_number"
      type     = "STRING"
      nullable = false
      comment  = "Semantic version number (e.g., 2.1.3)"
    },
    {
      name     = "version_name"
      type     = "STRING"
      nullable = true
      comment  = "Human-readable name for the version"
    },
    {
      name     = "version_description"
      type     = "STRING"
      nullable = true
      comment  = "Description of changes in this version"
    },
    {
      name     = "component_name"
      type     = "STRING"
      nullable = false
      comment  = "Name of ORCA component (core, scheduler, metadata, runtime)"
    },
    {
      name     = "git_repository"
      type     = "STRING"
      nullable = false
      comment  = "Git repository URL where code is stored"
    },
    {
      name     = "git_branch"
      type     = "STRING"
      nullable = false
      comment  = "Git branch for this version"
    },
    {
      name     = "git_commit_hash"
      type     = "STRING"
      nullable = false
      comment  = "Git commit hash for this version"
    },
    {
      name     = "build_number"
      type     = "STRING"
      nullable = true
      comment  = "CI/CD build number"
    },
    {
      name     = "build_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this version was built"
    },
    {
      name     = "release_date"
      type     = "TIMESTAMP"
      nullable = true
      comment  = "Timestamp when this version was released"
    },
    {
      name     = "is_current_version"
      type     = "BOOLEAN"
      nullable = false
      comment  = "Whether this is the currently deployed version"
    },
    {
      name     = "environment_deployments"
      type     = "STRING"
      nullable = true
      comment  = "JSON object tracking deployments to each environment"
    },
    {
      name     = "release_notes"
      type     = "STRING"
      nullable = true
      comment  = "Detailed release notes for this version"
    },
    {
      name     = "compatibility_notes"
      type     = "STRING"
      nullable = true
      comment  = "Backward compatibility and breaking changes information"
    },
    {
      name     = "created_date"
      type     = "TIMESTAMP"
      nullable = false
      comment  = "Timestamp when this version record was created"
    },
    {
      name     = "created_by"
      type     = "STRING"
      nullable = false
      comment  = "User or system that created this version record"
    }
  ]
}