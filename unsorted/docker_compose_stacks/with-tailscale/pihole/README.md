# Pi-hole with Tailscale

A Docker Compose stack that runs [Pi-hole](https://pi-hole.net/) behind [Tailscale](https://tailscale.com/), making your Pi-hole instance accessible only via your Tailnet.

## Services

- **Pi-hole** - Network-wide ad blocking DNS server
- **Tailscale** - Secure mesh VPN for private network access

## Setup

1. Change the `WEBPASSWORD` environment variable in `docker-compose.yaml` to a secure password
2. Start the stack:
   ```bash
   docker compose up -d
   ```
3. Get the Tailscale login URL:
   ```bash
   docker compose logs -f tailscale
   ```
4. Open the login URL in your browser to authenticate with Tailscale
5. Access Pi-hole's admin interface at `http://pihole:80/admin` from any device on your Tailnet

## Configuration

- **Timezone**: Set via `TZ` environment variable (default: `Europe/London`)
- **Web Password**: Set via `WEBPASSWORD` environment variable
- **DNS Listening Mode**: Set to `ALL` to accept queries from all origins

## Volumes

- `./etc-pihole` - Pi-hole configuration
- `./etc-dnsmasq.d` - dnsmasq configuration
- `./tailscale-data` - Tailscale state
