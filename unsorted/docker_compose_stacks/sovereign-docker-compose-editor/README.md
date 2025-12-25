# Sovereign Docker Compose Editor

A secure, web-based code editor for managing Docker Compose files, accessible through Tailscale.

## Overview

This stack provides a code-server instance that allows you to edit Docker Compose files through a web interface. It's connected to Tailscale for secure remote access and has direct access to the host's Docker socket for managing containers.

## Services

### code-server

- **Base Image**: `codercom/code-server:4.107.0-bookworm`
- **Purpose**: Web-based VS Code editor
- **Features**:
  - Docker CLI installed for container management
  - Password authentication
  - Accessible via Tailscale network

### tailscale

- **Image**: `tailscale/tailscale:v1.92.4`
- **Purpose**: Secure network access via Tailscale VPN
- **Hostname**: `sovereign-docker-compose-editor`

## Setup

1. **Configure Password**

   Edit the `PASSWORD` environment variable in the `docker-compose.yaml`:

   ```yaml
   environment:
     - PASSWORD=your-secure-password-here
   ```

2. **Tailscale Authentication**

   On first run, check the logs to get the Tailscale authentication URL:

   ```bash
   docker compose logs tailscale
   ```

   Visit the URL to authenticate the device to your Tailscale network.

3. **Start the Services**
   ```bash
   docker compose up -d
   ```

## Access

Once running and authenticated with Tailscale:

- Access the editor at: `http://sovereign-docker-compose-editor`
- Login with the password you configured

## Volumes

- `./config` - code-server configuration and settings
- `/mnt/user/root/docker-compose/` - Project directory (editable Docker Compose files)
- `./tailscale-data` - Tailscale state and configuration
- `/var/run/docker.sock` - Host Docker socket for container management

## Security Notes

- The editor runs as root to access the Docker socket
- Access is restricted to your Tailscale network
- Change the default password immediately
- The Docker socket provides full control over host containers - use with caution

## Managing Docker Containers

With the Docker CLI installed and socket mounted, you can:

- View running containers: `docker ps`
- Manage compose stacks: `docker compose up/down`
- View logs: `docker compose logs`
- All standard Docker commands are available

## Customization

### Change the Port

The editor listens on port 80 within the Tailscale network. To change:

```yaml
command: ["--bind-addr", "0.0.0.0:8080", "--auth", "password"]
```

### Change Project Directory

Update the volume mount to point to your Docker Compose files:

```yaml
volumes:
  - /your/compose/files:/home/coder/project
```
