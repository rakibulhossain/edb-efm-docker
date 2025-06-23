-- Initialize database users and privileges for PostgreSQL
-- This script is executed by the PostgreSQL Docker entrypoint in /docker-entrypoint-initdb.d/

-- Check if efm role exists and create if not
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'efm') THEN
        CREATE ROLE efm WITH LOGIN PASSWORD 'efm_password';
    END IF;
END
$$;

-- Grant privileges to efm role
ALTER ROLE efm REPLICATION;
GRANT EXECUTE ON FUNCTION pg_wal_replay_resume() TO efm;
GRANT EXECUTE ON FUNCTION pg_wal_replay_pause() TO efm;
GRANT pg_read_all_stats TO efm;
GRANT EXECUTE ON FUNCTION pg_reload_conf() TO efm;
GRANT pg_read_all_settings TO efm;
GRANT CONNECT ON DATABASE postgres TO efm;
GRANT USAGE ON SCHEMA public TO efm;

-- Check if repuser role exists and create if not
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'repuser') THEN
        CREATE ROLE repuser WITH REPLICATION LOGIN PASSWORD 'repl_password';
    END IF;
END
$$;
