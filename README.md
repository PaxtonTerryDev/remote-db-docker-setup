## Credentials

You need to login to the oracle container registry before building.

## Todo

set up k8 cluster to get docker credentials to pull from oracle container.
might need to check with oracle on permissions to do this.

## Key Terms

- Source - Where the database is coming from. (IE the production db being used to seed our dev db)
- Target - Our dev db being created in the container.

## General Process

The container intially runs a python program to build the config files.

- Setup (On initial container creation)
  1. Container start up, builds database.
  2. Once Database is initialized, executes data pump on source database.
     - Should check persistent volume for dump file - if one exists, it should use that.
     - Might be able to do this in one go - perform step 3 before initializing the database, use that data to initialize it.
  3. Copies dump file to machine, saves data to persistent volume on kubernetes.
  4. Uses dump file to create new database.

Each remote database will need unique deployment, namespace and other Rancher config files. (not sure what those are yet.) Will also need to figure out how to deploy to a Rancher project, preferably from the command line.

## Creating a new database with dmp file

The container will first attempt to create a new dmp file with the specifications outlined in [database_config.yaml](./database_config.yaml). I will outline the general process for this below, but it should be used primarily under supervision of a DBA

1. The target machine will tunnel into the machine running the 'source' database. Using the values provided in the [database_config.yaml](./database_config.yaml) file (under the source_database config), it will log in and attempt to start a datapump of the required schemas.
   - If no schemas are provided, it will attempt to export all schemas in the database (this is not recommended - database instances should be limited to the minimum schemas tables required for the application).
   - If no tables are provided for a schema, all tables will be exported.
   - **IF** the Data Pump fails, the container will throw an exception and shut down.
2. The target container will securely copy the output \*.dmp file from the source machine to the target machine.
3. The target container will initialize it's database using the .dmp file as a base.
4. After initialization is complete, the target will run a shell script that reconfigures the database to reflect the values specified in [database_config.yaml](./database_config.yaml) under `database`.
5. The database will run an integrity check
6. The database will set up chron backups as specified under `database.backups`
7. The database will open for connections.
