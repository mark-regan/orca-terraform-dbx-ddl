# Tables Configuration
# Dynamically load table configurations from the tables directory structure

locals {
  # Scan for all table.tf files in the tables directory
  table_files = fileset("${path.module}/tables", "*/*/*/table.tf")
  
  # Parse table configurations from files
  tables = {
    for file in local.table_files : 
    replace(file, "/table.tf", "") => {
      catalog = split("/", file)[0]
      schema  = split("/", file)[1]
      table   = split("/", file)[2]
      path    = "${path.module}/tables/${file}"
    }
  }
}

# Create tables using the delta-table module
module "tables" {
  for_each = local.tables

  source = "./modules/delta-table"
  
  # Use catalog from the new catalog modules or fall back to variable for backward compatibility
  catalog_name = try(
    module.catalogs[each.value.catalog].name,
    var.catalog_name  # Fallback for existing orca_catalog tables
  )
  
  # Schema name from path
  schema_name = each.value.schema
  
  # Table configurations will be loaded from individual table.tf files
  # These files should define the table using the delta-table module
  # We'll need to refactor existing table files to work with this approach
}

# Output table information
output "created_tables" {
  description = "List of all created tables with their full names"
  value = {
    for key, table in local.tables : key => {
      catalog = table.catalog
      schema  = table.schema
      table   = table.table
      full_name = "${table.catalog}.${table.schema}.${table.table}"
    }
  }
}