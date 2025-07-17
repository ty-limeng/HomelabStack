#!/bin/bash

# Load environment variables
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
. "$SCRIPT_DIR/.env"
source "$(dirname "$0")/telegram.sh"

SERVICE_NAME=${SERVICE_NAME:-Unknown}
SERVER_NAME=$(hostname)
LOG_FILE="/var/log/backup_${SERVER_NAME}.log"
exec > >(tee -a "$LOG_FILE") 2>&1
SSH_PORT=${PORT}

TIMESTAMP=$(date +"%a %b %d %Y %I:%M:%S %p")

if [ ! -d "$SRC_DIR" ]; then
    send_telegram "❌ Backup failed: Source directory $SRC_DIR does not exist."
    exit 1
fi

BACKUP_SIZE=$(du -sh "$SRC_DIR" | cut -f1)

RSYNC_OUTPUT=$(rsync -avz --stats -e "ssh -p $SSH_PORT" --delete "$SRC_DIR" "${DST_USR}@${IP}:${DST_DIR}")

if [ $? -eq 0 ]; then

    BYTES=$(echo "$RSYNC_OUTPUT" | grep "Total transferred file size:" | awk '{print $5}' | tr -d ',')
    BYTES=${BYTES:-0}
    TRANSFERRED_MB=$(echo "scale=2; $BYTES / 1024 / 1024" | bc)

    if (( $(echo "$TRANSFERRED_MB == 0" | bc -l) )); then
        TRANSFERRED_SIZE="0 MB (No Changes Made.)"
    else
        TRANSFERRED_SIZE="${TRANSFERRED_MB} MB"
    fi
        send_telegram $'✅ Backup from '"$SERVER_NAME"$'\n\n- Service: '"$SERVICE_NAME"$'\n\n- Time: '"$TIMESTAMP"$'\n\n- Total Size: '"$BACKUP_SIZE"$'\n\n- Changes Synced: '"$TRANSFERRED_SIZE"

else
        send_telegram $'❌ Backup failed from '"$SERVER_NAME"$'\n\n- Service: '"$SERVICE_NAME"$'\n\n- Time: '"$TIMESTAMP"$'\n\n- See log for details: '"$LOG_FILE"
    exit 1
fi
