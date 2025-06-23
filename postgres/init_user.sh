#!/bin/bash
set -e

# Initialize database users and privileges for PostgreSQL
check_role_exists() {
    local role_name="$1"
    psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres -t -c \
        "SELECT 1 FROM pg_roles WHERE rolname = '$role_name';" | grep -q 1
}

if ! check_role_exists "efm"; then
    psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres <<-EOSQL
        CREATE ROLE efm WITH LOGIN PASSWORD 'efm_password';
EOSQL
fi

psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres <<-EOSQL
    ALTER ROLE efm REPLICATION;
    GRANT EXECUTE ON FUNCTION pg_wal_replay_resume() TO efm;
    GRANT EXECUTE ON FUNCTION pg_wal_replay_pause() TO efm;
    GRANT pg_read_all_stats TO efm;
    GRANT EXECUTE ON FUNCTION pg_reload_conf() TO efm;
    GRANT pg_read_all_settings TO efm;
    GRANT CONNECT ON DATABASE postgres TO efm;
    GRANT USAGE ON SCHEMA public TO efm;
EOSQL

if ! check_role_exists "repuser"; then
    psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres <<-EOSQL
        CREATE ROLE repuser WITH REPLICATION LOGIN PASSWORD 'repl_password';
EOSQL
fi
