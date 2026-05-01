#!/bin/bash
set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/app_$TIMESTAMP"
SOURCE_DIR="/var/www/app"

mkdir -p "$BACKUP_DIR" || { echo "[ERROR] Could not create backup dir"; exit 1; }
cp -r "$SOURCE_DIR" "$BACKUP_DIR" || { echo "[ERROR] Copy failed"; exit 1; }

# Rotate: keep only last 7 backups
cd /var/backups && ls -t | tail -n +8 | xargs -r rm -rf

echo "[INFO] Backup saved to $BACKUP_DIR"
