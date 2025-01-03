#!/bin/bash

# Usage: ./get_dependencies.sh <SCHEMA_NAME>

if [ -z "$1" ]; then
    echo "Usage: $0 <SCHEMA_NAME>"
    exit 1
fi

SCHEMA_NAME=$1

# Database connection details
DB_USER="AD"
DB_PASS="a\$\$mt"
DB_HOST="192.168.112.21"
DB_PORT="1521"
DB_SID="db1dev1"

# Temporary file to hold SQL script
SQL_FILE="/tmp/get_dependencies.sql"
RESULT_FILE="/tmp/dependencies_${SCHEMA_NAME}.txt"
EXPORT_FILE="/tmp/expdp_command_${SCHEMA_NAME}.sh"

# Generate the SQL script to calculate size for each dependency excluding non-critical objects
echo "SET PAGESIZE 1000" >$SQL_FILE
echo "SET LINESIZE 200" >>$SQL_FILE
echo "SET FEEDBACK OFF" >>$SQL_FILE
echo "SET HEADING ON" >>$SQL_FILE

echo "SELECT D.REFERENCED_OWNER, ROUND(SUM(DISTINCT S.BYTES) / (1024 * 1024), 2) AS SIZE_MB" >>$SQL_FILE
echo "FROM DBA_DEPENDENCIES D" >>$SQL_FILE
echo "JOIN DBA_SEGMENTS S ON D.REFERENCED_NAME = S.SEGMENT_NAME AND D.REFERENCED_OWNER = S.OWNER" >>$SQL_FILE
echo "WHERE D.OWNER = UPPER('$SCHEMA_NAME')" >>$SQL_FILE
echo "  AND D.REFERENCED_OWNER IS NOT NULL" >>$SQL_FILE
echo "  AND S.SEGMENT_TYPE NOT IN ('INDEX', 'MATERIALIZED VIEW', 'TEMPORARY', 'LOBSEGMENT', 'LOBINDEX', 'TABLE PARTITION', 'INDEX PARTITION', 'MATERIALIZED VIEW LOG', 'CLUSTER')" >>$SQL_FILE
echo "  AND S.SEGMENT_NAME NOT LIKE 'LOG%'" >>$SQL_FILE
echo "GROUP BY D.REFERENCED_OWNER" >>$SQL_FILE
echo "ORDER BY SIZE_MB DESC;" >>$SQL_FILE

echo "EXIT;" >>$SQL_FILE

# Execute the SQL script using sqlplus
sqlplus -s ${DB_USER}/${DB_PASS}@"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${DB_HOST})(PORT=${DB_PORT}))(CONNECT_DATA=(SID=${DB_SID})))" @$SQL_FILE >$RESULT_FILE

# Check if the query was successful
if [ $? -eq 0 ]; then
    echo "Estimated sizes for each dependency excluding non-critical objects for schema $SCHEMA_NAME have been saved to $RESULT_FILE."
else
    echo "Failed to calculate the sizes. Please check your connection and schema name."
    exit 1
fi

# Parse the RESULT_FILE and create the expdp command
echo "#!/bin/bash" >$EXPORT_FILE
echo "expdp ${DB_USER}/${DB_PASS}@${DB_SID} \\" >>$EXPORT_FILE
echo "  directory=DATA_PUMP_DIR \\" >>$EXPORT_FILE
echo "  dumpfile=${SCHEMA_NAME}_dependencies.dmp \\" >>$EXPORT_FILE
echo "  logfile=${SCHEMA_NAME}_dependencies.log \\" >>$EXPORT_FILE
echo -n "  schemas=" >>$EXPORT_FILE

SCHEMAS=$(awk '/REFERENCED_OWNER/ {next} /^[A-Z]/ {print $1}' $RESULT_FILE | tr '\n' ',' | sed 's/,$//')
echo "$SCHEMAS" >>$EXPORT_FILE

chmod +x $EXPORT_FILE
echo "Export command script generated at: $EXPORT_FILE"
