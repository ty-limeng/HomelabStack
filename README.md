# 🧰 HomelabStack

Welcome to **HomelabStack**, a personal collection of Docker Compose stacks and Bash scripts designed to simplify and secure your self-hosted services.

This repository includes:
- 🐳 Organized `compose.yaml` files for each service
- 🛡️ Bash scripts for backing up Docker volumes and bind mounts
- 🔔 Telegram alert integration

---

## 📦 Docker Compose Stacks

All Docker services are organized under the `compose/` directory. Each folder contains a self-contained `compose.yaml` file for easy deployment.

### Available Services

| Service         | Description                         |
|-----------------|-------------------------------------|
| Actual-budget   | Budgeting software                  |
| Adguard         | Layer 7 ad blocker                  |
| Beszel          | Server monitoring solution          |
| Cloudflared     | Tunnels for public access           |
| Docmost         | Note taking app                     |
| Homeassistant   | Smart home & IoT mangement          |
| Immich          | Self-hosted photo and video backup  |
| Mqtt            | MQTT broker (e.g. Mosquitto)        |
| Nextcloud       | Self-hosted file storage & collabora|
| Nginx-proxy     | Reverse proxy with SSL              |
| Vaultwarden     | Lightweight password manager        |
| yt-dlp          | YouTube/media downloader            |

> 💡 Each service is configured in a way that prioritizes modularity and simplicity.

---

## 🔐 Backup Scripts

Located in the `bash/backup/` directory:

### `docker_volume.sh`

Backs up data stored in Docker-managed volumes.

### `bind_mount.sh`

Backs up directories bind-mounted into containers (e.g., `/opt/data:/data`).

> These scripts help preserve critical data even if a container is removed or the host is reinstalled.

---

## 🔔 Alerts via Telegram

Located in `bash/alert/telegram.sh`, this script allows integration with [Telegram Bot API](https://core.telegram.org/bots/api) for:
- Notifying backup success/failure
- Custom triggers

---

## 🧪 Usage Tips

### Run a Docker stack:

```bash
cd compose/homeassistant
docker compose up -d
