# docker-compose.bash

A bash script for managing multiple Docker Compose stacks from a single root directory. Designed for servers running multiple containerized services.

## Features

- Automatically detects and manages all Docker Compose projects in subdirectories
- Supports multiple compose file naming conventions (`compose.yaml`, `compose.yml`, `docker-compose.yaml`, `docker-compose.yml`)
- Provides batch operations across all stacks
- Includes scheduled task commands for automation (cron-friendly)

## Configuration

By default, the script looks for compose stacks in:

```bash
ROOT_DIR="/mnt/user/root/docker-compose"
```

Modify this variable to match your setup.

## Usage

```bash
./docker-compose.bash <command>
```

### Commands

| Command | Description                                                 |
| ------- | ----------------------------------------------------------- |
| `up`    | Start all compose stacks in detached mode                   |
| `down`  | Stop all compose stacks                                     |
| `pull`  | Pull latest images for all stacks                           |
| `build` | Build images for all stacks                                 |
| `prune` | Remove all unused Docker data (images, containers, volumes) |

### Scheduled Task Commands

These commands are designed for use with cron or other schedulers:

| Command    | Description                                    |
| ---------- | ---------------------------------------------- |
| `minutely` | No-op (placeholder for future use)             |
| `hourly`   | Runs `up` to ensure all services are running   |
| `daily`    | Runs system prune to clean up unused resources |
| `reboot`   | Starts all stacks and prunes the system        |

## Example Directory Structure

```
/mnt/user/root/docker-compose/
├── pihole/
│   └── docker-compose.yaml
├── nginx/
│   └── compose.yaml
└── postgres/
    └── docker-compose.yml
```

## Example Cron Setup

```cron
@hourly   /path/to/docker-compose.bash hourly
@daily    /path/to/docker-compose.bash daily
@reboot   /path/to/docker-compose.bash reboot
```
