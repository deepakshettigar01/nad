#!/usr/bin/env bash

plugin_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd -P)
pgfuncs="${plugin_dir}/pg_functions.sh"
[[ -f $pgfuncs ]] && source $pgfuncs
[[ ${pg_functions:-0} -eq 0 ]] && { echo "Invalid plugin configuration."; exit 1; }

LINEBREAKS=$'\n\b'

DB_LIST=$($PSQL -U $PGUSER -d $PGDATABASE -p $PGPORT -w -F, -Atc "select datname,pg_database_size(datname) from pg_database;")

for db in $DB_LIST; do
    IFS=','
    DATA=( $db )
    print_uint ${DATA[0]} ${DATA[1]}
done

# END
