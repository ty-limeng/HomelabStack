# README

# Overview

**Beszel** is a lightweight container-based disk and system monitoring tool.  
You can run:

- A **central monitoring server** with the web dashboard (UI) and `beszel-agent`
- One or more **client servers**, each running a `beszel-agent` container

Agents send monitoring data either via:

- **Unix Socket** – when running on the same host or in the same Docker stack
- **Port + Key** – when running on a different machine (remote server)

---

# 1\. Prerequisites

Install Docker on all servers:

```bash
curl -s https://get.docker.com | sh
```

---

# 2\. Main Server Setup (Dashboard + Agent)

This server hosts the Beszel **web UI** and also runs the agent.

## Folder Structure (example):

```
beszel/
├── compose.yaml
├── beszel_data/
└── beszel_socket/
```

## compose.yaml:

```yaml
services:
  beszel:
    image: henrygd/beszel:latest
    container_name: beszel
    restart: unless-stopped
    ports:
# This port can be custom like 5000:8090 just make sure port mapping to internal docker network is correct.
      - 8090:8090
    volumes:
      - ./beszel_data:/beszel_data
      - ./beszel_socket:/beszel_socket
# Leave his 'networks' comment is using custom or default docker network.
#    networks:
#      - proxy

  beszel-agent:
    image: henrygd/beszel-agent
    container_name: beszel-agent
    restart: unless-stopped
    network_mode: host
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./beszel_socket:/beszel_socket
      # Optional: monitor other disks/partitions
      # - /mnt/disk/.beszel:/extra-filesystems/sda1:ro
    environment:
      LISTEN: /beszel_socket/beszel.sock
      KEY: "Public Key from Main Server Dashboard"
# Leave this 'networks' comment is using custom or default docker network.
#networks:
#  proxy:
#    external: true
```

### Notes:

- `LISTEN` is a Unix socket used for local communication between dashboard and agent.
- `KEY` is needed for both main server and remote agents. 
- `network_mode: host` allows full access to host’s network (needed for monitoring).

### Start the stack:

```bash
docker compose up -d
```

Access the dashboard at:  
`http://<main-server-ip>:8090`

---

# 3\. Remote Server Agent (Different Machine)

This is for **client servers** that send data to the main dashboard over a **TCP port** with a **public key**.

## compose.yaml (remote agent only):

```yaml
services:
  beszel-agent:
    image: henrygd/beszel-agent
    container_name: beszel-agent
    restart: unless-stopped
    network_mode: host
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      # Mount disk/partition you want to monitor
      - /mnt/emmc:/extra-filesystems/emmc:ro
    environment:
      LISTEN: 45876
      KEY: "<Public Key from Main Server Dashboard>"
```

### How to Get the Key:

1.  Open the Beszel Dashboard on your main server.
2.  Go to **Agents** tab.
3.  Copy the **Public Key**.
4.  Paste it into the `KEY` environment variable above.

### Start the agent:

```bash
docker compose up -d
```
