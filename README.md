# Illumio CI Workloader Import

A containerized utility for importing workloads into Illumio PCE (Policy Compute Engine) using the Workloader CLI tool.

## Overview

This project provides a Docker container that bundles the [Workloader CLI tool](https://github.com/brian1917/workloader) for automating Illumio PCE operations, particularly focused on workload imports. It simplifies the process of importing workloads from CSV files in CI/CD pipelines or automated environments.

## Features

- Pre-built Docker container with Workloader CLI
- Easy PCE configuration through environment variables or config files
- Simplified workload import from CSV files
- Suitable for CI/CD pipelines and automated deployment

## Prerequisites

- Docker
- Access to an Illumio PCE instance
- PCE credentials (API key and secret)
- CSV file formatted for Workloader's wkld-import command

## Quick Start

### Pull the Docker image

```bash
docker pull your-registry/illumio-ci-workloader-import:latest
```

### Run a workload import

```bash
docker run -v $(pwd)/data:/app/data \
  -e PCE_HOST=your-pce.example.com \
  -e PCE_PORT=8443 \
  -e PCE_USER=api_user \
  -e PCE_KEY=api_secret_key \
  -e WORKLOADER_CSV_FILE=your-workloads.csv \
  your-registry/illumio-ci-workloader-import:latest wkld-import
```

## Configuration

### Environment Variables

- `PCE_HOST`: PCE hostname (FQDN)
- `PCE_PORT`: PCE port (usually 8443)
- `PCE_USER`: PCE API username
- `PCE_KEY`: PCE API key
- `PCE_ORG`: PCE organization ID (defaults to 1)
- `PCE_CREDENTIALS_FILE`: Path to a pce.yaml file (alternative to individual environment variables)
- `FORCE_PCE_CONFIG`: When set to "true", will recreate the PCE configuration even if it already exists
- `WORKLOADER_CSV_FILE`: Path to the CSV file for workload import (relative to /app/data)

### Volume Mounts

- `/app/data`: Mount point for your data files, including CSV files for import
- `/app/config`: Mount point for configuration files

### Custom Commands

You can run any Workloader command by passing it after the image name:

```bash
docker run your-registry/illumio-ci-workloader-import:latest [workloader-command] [options]
```

## Building the Image

```bash
docker build -t your-registry/illumio-ci-workloader-import:latest .
```

## CSV File Format

The CSV file should follow the format required by Workloader's wkld-import command. See [Workloader documentation](https://github.com/brian1917/workloader) for details.

## License

This project is distributed under the same license as the Workloader tool.
