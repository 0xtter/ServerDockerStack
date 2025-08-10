#!/bin/bash

# Usage:
# ./ServerDockerStack.sh up|down path/to/example.env path/to/project-folder

ACTION=$1
ENV_FILE=$2
PROJECT_DIR=$3

if [[ -z "$ACTION" || -z "$ENV_FILE" || -z "$PROJECT_DIR" ]]; then
    echo "Usage: $0 up|down <env-file> <project-dir>"
    exit 1
fi

if [[ "$ACTION" != "up" && "$ACTION" != "down" ]]; then
    echo "Error: first argument must be 'up' or 'down'"
    exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: env file '$ENV_FILE' not found."
    exit 1
fi

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "Error: project directory '$PROJECT_DIR' not found."
    exit 1
fi

# Function to run docker compose command in a subfolder
run_compose() {
    local folder="$1"
    if [[ -f "$folder/docker-compose.yaml" ]]; then
        echo "Running docker compose $ACTION in $folder"
        docker compose --env-file "$ENV_FILE" -f "$folder/docker-compose.yaml" $ACTION -d
    else
        echo "No docker-compose.yaml in $folder, skipping."
    fi
}

# Bring services up
if [[ "$ACTION" == "up" ]]; then
    # Start network first
    run_compose "$PROJECT_DIR/network"

    # Then start the rest
    for service in media monitoring other; do
        run_compose "$PROJECT_DIR/$service"
    done
else
    # Bring all down
    for service in media monitoring other; do
        run_compose "$PROJECT_DIR/$service"
    done

    # Stop network last
    run_compose "$PROJECT_DIR/network"
fi
