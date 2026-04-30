#!/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/app_$TIMESTAMP"
mkdir -p "$BACKUP_DIR"
cp -r /var/www/app "$BACKUP_DIR"
echo "Backup saved to $BACKUP_DIR"
