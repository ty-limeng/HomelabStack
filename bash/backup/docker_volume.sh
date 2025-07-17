#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
. "$SCRIPT_DIR/.env"
source "$(dirname "$0")/telegram.sh"

# [*] Deleting old local backups
rm -f $SCRIPT_DIR/${VOLUME_NAME}_backup_*.tar.gz

# [*] Creating new Docker volume backup
docker run --rm \
  -v ${VOLUME_NAME}:/data:ro \
  -v $SCRIPT_DIR:/backup \
  busybox \
  tar czf "/backup/${BACKUP_NAME}" -C /data .

if [[ $? -ne 0 ]]; then
  send_telegram "❌ Backup failed on $(hostname)

  - Service: "${SERVICE}"

  - Time: $(date +"%a %b %d %Y %I:%M:%S %p")"

  exit 1
fi

# [*] Deleting old backups on remote server
ssh "${REMOTE_USER}@${REMOTE_HOST}" "rm -f ${REMOTE_DIR}/${VOLUME_NAME}_backup_*.tar.gz"

# [*] Transferring backup to remote server
scp "$SCRIPT_DIR/${BACKUP_NAME}" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

if [[ $? -eq 0 ]]; then
  send_telegram "✅ Backup successfully transferred from $(hostname).

  - Service: ${SERVICE}

  - Destination: NAS

  - Time: $(date +"%a %b %d %Y %I:%M:%S %p")"
else
  send_telegram "❌ Transfer failed from $(hostname).

  - Service: ${SERVICE}

  - Destinatoin: NAS

  - Time: $(date +"%a %b %d %Y %I:%M:%S %p")"
fi
