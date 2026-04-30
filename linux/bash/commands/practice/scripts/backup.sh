#!/bin/bash
set -e
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/app_$TIMESTAMP"
mkdir -p "$BACKUP_DIR" || { echo "[ERROR] Could not create backup dir"; exit 1; }
cp -r /var/www/app "$BACKUP_DIR" || { echo "[ERROR] Copy failed"; exit 1; }
echo "[INFO] Backup saved to $BACKUP_DIR"
