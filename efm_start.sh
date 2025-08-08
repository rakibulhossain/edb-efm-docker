#!/bin/bash

set -ex

export EFMPASS="efm_password"
ENCRYPTED_PASS=`(/usr/edb/efm-5.0/bin/efm encrypt main --from-env)`

cp /etc/edb/efm-5.0/main.properties main.properties.bak

## node parameters
sed -i "s|^db.password.encrypted=.*|db.password.encrypted=$ENCRYPTED_PASS|" main.properties.bak

cp main.properties.bak /etc/edb/efm-5.0/main.properties

chown -R efm:efm /etc/edb/efm-5.0/main.properties
chmod 0644 /etc/edb/efm-5.0/main.properties


chown -R efm:efm /etc/edb/efm-5.0/main.nodes
chmod 0644 /etc/edb/efm-5.0/main.nodes


/usr/edb/efm-5.0/bin/runefm.sh start main

CLUSTER_NAME="main"
PID_FILE="/var/run/efm-5.0/${CLUSTER_NAME}.pid"

while true; do
  if [[ ! -f "$PID_FILE" ]]; then
    echo "[ERROR] EFM PID file not found: $PID_FILE"
    exit 1
  fi

  PID=$(cat "$PID_FILE")

  if ps -p "$PID" > /dev/null && ps -p "$PID" -o cmd= | grep -q "[e]fm-5.0"; then
    sleep 5
  else
    echo "[ERROR] $(date) - EFM process not running or mismatched PID"
    exit 1
  fi

done
