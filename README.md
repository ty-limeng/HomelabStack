# 🧰 HomelabStack

Welcome to **HomelabStack**, a personal collection of Docker Compose stacks and Bash scripts designed to simplify and secure your self-hosted services.

This repository includes:
- 🐳 Organized `docker-compose.yaml` files for each service
- 🛡️ Bash scripts for backing up Docker volumes and bind mounts
- 🔔 Telegram alert integration

---

## 📦 Docker Compose Stacks

All Docker services are organized under the `compose/` directory. Each folder contains a self-contained `compose.yaml` file for easy deployment.

### Available Services

| Service         | Description                         |
|-----------------|-------------------------------------|
| actual-budget   | Budgeting software                  |
| adguard         | Network-wide ad blocker             |
| beszel          | Disk monitoring or internal agent   |
| cloudflared     | Tunnels for public access           |
| docmost         | Document management or viewer       |
| homeassistant   | Home automation platform            |
| immich          | Self-hosted photo and video backup  |
| mqtt            | MQTT broker (e.g. Mosquitto)        |
| nextcloud       | Self-hosted file storage            |
| nginx-proxy     | Reverse proxy with SSL              |
| vaultwarden     | Lightweight password manager        |
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
- Disk space alerts
- Custom triggers

---

## 🧪 Usage Tips

### Run a Docker stack:

```bash
cd compose/homeassistant
docker compose up -d
