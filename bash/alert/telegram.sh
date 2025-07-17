#!/bin/bash
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
. "$SCRIPT_DIR/.env"

send_telegram() {
    local message="$1"
    local url="https://api.telegram.org/bot${TEL_TOKEN}/sendMessage"

    curl -s -o /dev/null -X POST "$url" \
        --data-urlencode "chat_id=${TEL_CHAT_ID}" \
        --data-urlencode "text=${message}"
}

send_telegram "$@"
