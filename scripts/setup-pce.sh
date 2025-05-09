#!/bin/bash
set -e

PCE_CONFIG_DIR="/app/workloader"
PCE_YAML="${PCE_CONFIG_DIR}/pce.yaml"

# If pce.yaml already exists and FORCE_PCE_CONFIG is not set, we'll use it
if [ -f "$PCE_YAML" ] && [ "$FORCE_PCE_CONFIG" != "true" ]; then
    echo "Found existing PCE configuration at ${PCE_YAML}"
    # Link the config file to the default location for workloader
    mkdir -p ~/.workloader
    ln -sf "$PCE_YAML" ~/.workloader/pce.yaml
    exit 0
fi

# Check if we need to set up PCE configuration
if [ -n "$PCE_CREDENTIALS_FILE" ] && [ -f "$PCE_CREDENTIALS_FILE" ]; then
    echo "Using PCE credentials file: $PCE_CREDENTIALS_FILE"
    # Create config directory if it doesn't exist
    mkdir -p "$PCE_CONFIG_DIR"
    
    # Copy the credentials file to the config location
    cp "$PCE_CREDENTIALS_FILE" "$PCE_YAML"
elif [ -n "$PCE_HOST" ] && [ -n "$PCE_PORT" ] && [ -n "$PCE_USER" ] && [ -n "$PCE_KEY" ]; then
    echo "Setting up PCE configuration from environment variables"
    
    # Create config directory if it doesn't exist
    mkdir -p "$PCE_CONFIG_DIR"
    
    # Create pce.yaml file from environment variables
    cat > "$PCE_YAML" <<EOF
default-pce:
  disabletlschecking: false
  fqdn: ${PCE_HOST}
  port: ${PCE_PORT}
  org: ${PCE_ORG:-1}
  user: ${PCE_USER}
  key: ${PCE_KEY}
continue_on_error: false
debug: false
default_pce_name: default-pce
log_file: workloader.log
max_entries_for_stdout: 100
no_prompt: false
output_format: csv
target_pce: ""
update_pce: false
verbose: false
EOF
else
    echo "Error: PCE configuration not provided"
    echo "Please provide either:"
    echo "  - PCE_CREDENTIALS_FILE environment variable pointing to your pce.yaml file"
    echo "  - PCE_HOST, PCE_PORT, PCE_USER, and PCE_KEY environment variables"
    exit 1
fi

echo "PCE configuration created at ${PCE_YAML}"

# Link the config file to the default location for workloader
mkdir -p ~/.workloader
ln -sf "$PCE_YAML" ~/.workloader/pce.yaml
