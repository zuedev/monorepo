# Pi-hole Docker Stack

A Docker Compose configuration for running [Pi-hole](https://pi-hole.net/), a network-wide ad blocker that acts as a DNS sinkhole.

## Features

- DNS-based ad blocking for your entire network
- Web-based admin interface
- DHCP server capability
- NTP server for time synchronization

## Exposed Ports

| Port | Protocol | Service               |
| ---- | -------- | --------------------- |
| 53   | TCP/UDP  | DNS                   |
| 80   | TCP      | HTTP (Web Interface)  |
| 443  | TCP      | HTTPS (Web Interface) |
| 67   | UDP      | DHCP                  |
| 123  | UDP      | NTP                   |

## Configuration

### Environment Variables

| Variable                         | Description                  | Default         |
| -------------------------------- | ---------------------------- | --------------- |
| `TZ`                             | Timezone                     | `Europe/London` |
| `FTLCONF_webserver_api_password` | Admin web interface password | `CHANGEME`      |
| `FTLCONF_dns_listeningMode`      | DNS listening mode           | `ALL`           |

> ⚠️ **Important:** Change `FTLCONF_webserver_api_password` to a secure password before deployment.

### Volumes

- `./etc-pihole` - Pi-hole configuration files
- `./etc-dnsmasq.d` - dnsmasq configuration files

### Capabilities

The container requires the following Linux capabilities:

- `NET_ADMIN` - Network administration (required for DHCP)
- `SYS_TIME` - System time modification (required for NTP)
- `SYS_NICE` - Process priority adjustment

## Usage

### Starting the Stack

```bash
docker compose up -d
```

### Accessing the Web Interface

Navigate to `http://<host-ip>/admin` and log in with the password set in `FTLCONF_webserver_api_password`.

### Stopping the Stack

```bash
docker compose down
```

### Viewing Logs

```bash
docker compose logs -f pihole
```

## Network Configuration

To use Pi-hole as your DNS server, configure your devices or router to use the host machine's IP address as the primary DNS server.

### Option 1: Per-Device

Set the DNS server on individual devices to point to the Pi-hole host IP.

### Option 2: Router-Level

Configure your router's DHCP settings to distribute the Pi-hole host IP as the DNS server to all clients.

### Option 3: DHCP Server

Disable DHCP on your router and let Pi-hole handle DHCP by configuring it through the web interface.

## Image Version

This stack uses Pi-hole version `2025.11.1`.
