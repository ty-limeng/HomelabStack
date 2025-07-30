#!/bin/bash
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
. "$SCRIPT_DIR/.env"
source "$(dirname "$0")/telegram.sh"

# Service Path
#STACK_DIR="/opt/stacks"

for STACK in "${STACK_DIR}"/*; do
  # Check directory for compose.yaml
  if [ -d "$STACK" ]; then
    COMPOSE_FILE=""

    if [ -f "$STACK/compose.yaml" ]; then
      COMPOSE_FILE="$STACK/compose.yaml"

    elif [ -f "$STACK/docker-compose.yml" ]; then
      COMPOSE_FILE="$STACK/docker-compose.yml"
    # Condition for empty compose file
    else
      # Uncomment this for manual inspection and update
      #echo "⚠️  No compose file found in $STACK — skipping."
      continue
    fi
    # Uncomment this for manual inspection and update
    #echo "🔄 Updating stack: $(basename "$STACK")"

    docker compose -f "$COMPOSE_FILE" pull
    docker compose -f "$COMPOSE_FILE" down
    docker image prune -f
    docker compose -f "$COMPOSE_FILE" up -d

    #echo "✅ Finished updating $(basename "$STACK")"
    #echo "---------------------------------------"
  fi
done
send_telegram "✅  Finished updating docker images from $(hostname).
