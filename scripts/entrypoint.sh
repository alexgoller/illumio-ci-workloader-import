#!/bin/bash
set -e

# Setup PCE connection
/app/setup-pce.sh

# Check if we need to run wkld-import
if [ "$1" == "wkld-import" ]; then
    # Check if CSV file is provided
    if [ -z "$WORKLOADER_CSV_FILE" ]; then
        echo "Error: WORKLOADER_CSV_FILE environment variable is not set"
        echo "Please set WORKLOADER_CSV_FILE to the path of your CSV file inside the /app/data directory"
        exit 1
    fi

    if [ ! -f "$WORKLOADER_CSV_FILE" ]; then
        echo "Error: CSV file not found at $WORKLOADER_CSV_FILE"
        exit 1
    fi

    # Execute workloader with the specified CSV file
    echo "Running workloader wkld-import with $WORKLOADER_CSV_FILE"
    cd /app/workloader
    exec workloader wkld-import "/app/data/$WORKLOADER_CSV_FILE" "${@:2}" --no-prompt --update-pce --umwl
elif [ "$1" == "bash" ] || [ "$1" == "sh" ]; then
    # Allow interactive shell access
    exec "$@"
else
    # Pass all arguments directly to workloader
    exec workloader "$@"
fi
