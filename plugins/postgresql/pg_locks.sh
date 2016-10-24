#!/usr/bin/env bash

plugin_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd -P)
pgfuncs="${plugin_dir}/pg_functions.sh"
[[ -f $pgfuncs ]] && source $pgfuncs
[[ ${pg_functions:-0} -eq 0 ]] && { echo "Invalid plugin configuration."; exit 1; }

IFS=','
LINEBREAKS=$'\n\b'
LOCKS=$($PSQL -U $PGUSER -d $PGDATABASE -p $PGPORT -w -F, -Atc "select 'locks', count(*) as total, count(nullif(granted,true)) as waiting, count(nullif(mode ilike '%exclusive%',false)) as exclusive from pg_locks")

DATA=( $LOCKS )

TOTAL=${DATA[1]}
WAITING=${DATA[2]}
EXCLUSIVE=${DATA[3]}

print_uint total $TOTAL
print_uint waiting $WAITING
print_uint exclusive $EXCLUSIVE

# END
