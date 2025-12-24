#!/bin/bash

ROOT_DIR="/mnt/user/root/docker-compose"

# make sure we're in the right directory
cd $ROOT_DIR

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
    # get list of subdirectories
    for dir in $(ls -d */); do
        # remove trailing slash
        dir=${dir%?}
        # check if directory contains a compose file
        if has_compose_file "$dir"; then
            # run docker compose
            cd $dir && $@ && cd ..
        fi
    done
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
*)
    echo "Unrecognized command: $1"
    ;;
esac
