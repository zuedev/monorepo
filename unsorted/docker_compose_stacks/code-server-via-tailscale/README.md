# Code Server via Tailscale

This Docker Compose stack deploys [code-server](https://github.com/coder/code-server) (VS Code in the browser) accessible securely through your [Tailscale](https://tailscale.com/) network.

## What This Does

- Runs code-server (web-based VS Code) on port 80
- Exposes code-server exclusively through Tailscale (not accessible on local network)
- Provides secure remote access to your development environment from anywhere on your Tailnet

## Prerequisites

- Docker and Docker Compose installed
- A Tailscale account
- Tailscale authentication key (get one from [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys))

## Configuration

### 1. Set Code Server Password

Edit `docker-compose.yaml` and change the default password:

```yaml
environment:
  - PASSWORD=CHANGEME # Change this to a secure password
```

### 2. Configure Tailscale

Before starting the stack, you need to provide a Tailscale auth key. You can either:

**Option A: Set environment variable**

```bash
export TS_AUTHKEY="tskey-auth-xxxxx"
```

**Option B: Edit docker-compose.yaml**

Add the auth key to the tailscale service environment variables:

```yaml
environment:
  - TS_AUTHKEY=tskey-auth-xxxxx
  - TS_AUTH_ONCE="true"
  - TS_STATE_DIR=/var/lib/tailscale
```

### 3. (Optional) Customize Hostname

The service will appear as `code-server` in your Tailscale admin console. To change this, edit the `hostname` field in the tailscale service.

## Deployment

1. Start the stack:

   ```bash
   docker compose up -d
   ```

2. Check that both services are running:

   ```bash
   docker compose ps
   ```

3. View logs to confirm Tailscale authentication:
   ```bash
   docker compose logs tailscale
   ```

## Accessing Code Server

1. Find your code-server URL in the [Tailscale Admin Console](https://login.tailscale.com/admin/machines)
2. Navigate to `http://code-server` (or the custom hostname you set) in your browser
3. Enter the password you configured
4. Start coding!

## Directory Structure

After deployment, the following directories will be created:

- `./config` - Code-server configuration and settings
- `./project` - Your project files and workspace
- `./tailscale-data` - Tailscale state data (authentication and network info)

## Important Notes

- **Security**: Code-server is only accessible through your Tailscale network, providing zero-trust security
- **Network Mode**: The code-server container uses the tailscale service's network stack (`network_mode: service:tailscale`)
- **Password**: Make sure to change the default password before deploying to production
- **Persistence**: All data is stored in local volumes, so your work persists across container restarts
- **Resource Access**: The tailscale service needs `NET_ADMIN` and `NET_RAW` capabilities to manage the VPN tunnel

## Stopping the Stack

```bash
docker compose down
```

To remove all data (including your projects):

```bash
docker compose down -v
rm -rf config project tailscale-data
```

## Troubleshooting

### Can't connect to code-server

1. Verify Tailscale is authenticated:

   ```bash
   docker compose logs tailscale
   ```

2. Check that both containers are running:

   ```bash
   docker compose ps
   ```

3. Ensure you're connected to Tailscale on your client device

### Authentication issues

- Make sure your Tailscale auth key is valid and not expired
- Auth keys can be reusable or one-time use - check your key settings in the Tailscale admin console

## Version Information

- **code-server**: 4.107.0-39
- **tailscale**: v1.92.4
