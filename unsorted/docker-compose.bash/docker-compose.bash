#!/bin/bash

ROOT_DIR="/mnt/user/root/docker-compose"

# check pwd to see if we're in coder, change root dir
if [[ "$(pwd)" == "/home/coder/project" ]]; then
    ROOT_DIR="/home/coder/project"
fi

LOG_DIR="$ROOT_DIR/logs"

# color setup (ANSI, with tput fallback). Disabled if not a TTY.
if [ -t 1 ]; then
    if command -v tput >/dev/null 2>&1; then
        BOLD=$(tput bold)
        RESET=$(tput sgr0)
        BLUE=$(tput setaf 4)
        GREEN=$(tput setaf 2)
        RED=$(tput setaf 1)
        YELLOW=$(tput setaf 3)
    else
        BOLD='\033[1m'
        RESET='\033[0m'
        BLUE='\033[34m'
        GREEN='\033[32m'
        RED='\033[31m'
        YELLOW='\033[33m'
    fi
else
    BOLD=''
    RESET=''
    BLUE=''
    GREEN=''
    RED=''
    YELLOW=''
fi

# make sure we're in the right directory
cd $ROOT_DIR

# ensure logs directory exists
mkdir -p "$LOG_DIR"

# list of compose files to detect (in order of priority)
COMPOSE_FILES=("compose.yaml" "compose.yml" "docker-compose.yaml" "docker-compose.yml")

function has_compose_file {
    for file in "${COMPOSE_FILES[@]}"; do
        if [ -f "$1/$file" ]; then
            return 0
        fi
    done
    return 1
}

function execute_in_subdir {
    # check if directory exists
    if [ -d "$1" ]; then
        # run command in directory
        cd $1 && $2 && cd ..
    fi
}

function execute_in_all_subdirs {
    # command to run (preserve spacing)
    local cmd="$*"
    local dirs=()
    local pids=()

    # iterate subdirectories safely
    for d in */; do
        # remove trailing slash
        local dir="${d%/}"
        # check if directory contains a compose file
        if has_compose_file "$dir"; then
            local logfile="$LOG_DIR/${dir}.log"
            printf "[%s] %s▶%s %s%s%s: %s → %s\n" "$(date -Is)" "$BLUE" "$RESET" "$BOLD" "$dir" "$RESET" "$cmd" "$logfile"
            (
                echo "[$(date -Is)] START ${dir}: ${cmd}" > "$logfile"
                cd "$dir" && eval "$cmd" >> "$logfile" 2>&1
                local status=$?
                echo "[$(date -Is)] END ${dir} status=${status}" >> "$logfile"
                exit $status
            ) &
            dirs+=("$dir")
            pids+=("$!")
        fi
    done

    # wait for all background jobs to complete and summarize
    local i status failcount=0
    for i in "${!pids[@]}"; do
        local dir="${dirs[$i]}"
        wait "${pids[$i]}"
        status=$?
        if [ $status -eq 0 ]; then
            printf "[%s] %s✔%s %s completed\n" "$(date -Is)" "$GREEN" "$RESET" "$dir"
        else
            printf "[%s] %s✖%s %s failed (status %d). See %s/%s.log\n" "$(date -Is)" "$RED" "$RESET" "$dir" "$status" "$LOG_DIR" "$dir"
            failcount=$((failcount+1))
        fi
    done

    # return non-zero if any failures
    if [ $failcount -gt 0 ]; then
        return 1
    fi
}

function dc_pull_up {
    # check if directory contains a compose file
    if has_compose_file "$1"; then
        # run docker compose
        cd $ROOT_DIR/$1 && docker compose pull && docker compose up -d --remove-orphans && cd $ROOT_DIR
    fi
}

function dc_build_up {
    # check if directory contains a compose file
    if has_compose_file "$1"; then
        # run docker compose
        cd $ROOT_DIR/$1 && docker compose build && docker compose up -d --remove-orphans && cd $ROOT_DIR
    fi
}

case $1 in
up)
    execute_in_all_subdirs "docker compose up -d --remove-orphans"
    ;;
down)
    execute_in_all_subdirs "docker compose down"
    ;;
pull)
    execute_in_all_subdirs "docker compose pull"
    ;;
build)
    execute_in_all_subdirs "docker compose build"
    ;;
prune)
    docker system prune --all --volumes --force
    ;;
minutely)
    echo "Nothing to do!"
    ;;
hourly)
    execute_in_all_subdirs "docker compose up -d --remove-orphans"
    ;;
daily)
    docker system prune --all --volumes --force
    ;;
reboot)
    execute_in_all_subdirs "docker compose up -d --remove-orphans"
    docker system prune --all --volumes --force
    ;;
check-tags)
    issues_total=0
    problematic_images=()
    
    for d in */; do
        dir="${d%/}"
        if has_compose_file "$dir"; then
            printf "[%s] %s▶%s Checking %s%s%s...\n" "$(date -Is)" "$BLUE" "$RESET" "$BOLD" "$dir" "$RESET"
            cd "$dir"
            images=$(docker compose config 2>/dev/null | grep -E '^\s*image:' | awk '{print $2}')
            has_issues=0
            
            while IFS= read -r image; do
                if [ -n "$image" ]; then
                    if [[ "$image" != *":"* ]] || [[ "$image" == *":latest" ]]; then
                        printf "  %s⚠%s %s\n" "$YELLOW" "$RESET" "$image"
                        has_issues=1
                        issues_total=$((issues_total+1))
                        problematic_images+=("$dir: $image")
                    fi
                fi
            done <<< "$images"
            
            if [ $has_issues -eq 0 ]; then
                printf "[%s] %s✔%s %s: No issues found\n" "$(date -Is)" "$GREEN" "$RESET" "$dir"
            fi
            
            cd "$ROOT_DIR"
        fi
    done
    
    if [ $issues_total -gt 0 ]; then
        printf "\n%s⚠ Found %d image(s) with dynamic tags:%s\n" "$YELLOW" "$issues_total" "$RESET"
        for img in "${problematic_images[@]}"; do
            printf "  - %s\n" "$img"
        done
        exit 1
    else
        printf "\n%s✔ All images use pinned tags%s\n" "$GREEN" "$RESET"
    fi
    ;;
*)
    echo "Unrecognized command: $1"
    ;;
esac
