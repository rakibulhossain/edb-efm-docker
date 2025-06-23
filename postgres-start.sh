postgres
while true
do
  RETRIES=60
  while ! pg_isready -U postgres -d postgres > /dev/null 2>&1; do
    echo "[INFO] Waiting for PostgreSQL to be ready..."
    sleep 1
    ((RETRIES--))
    if [ "$RETRIES" -le 0 ]; then
      echo "[ERROR] PostgreSQL did not become ready in time"
      exit 1
    fi
  done
done
