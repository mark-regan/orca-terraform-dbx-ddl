-- tags: dml,seed
USE CATALOG ${CATALOG_ORCA};
USE SCHEMA ${SCHEMA_ORCA_METADATA};
INSERT INTO ${SCHEMA_ORCA_METADATA}.example_table (id, name)
VALUES (1, 'alpha'), (2, 'beta');

