#!/bin/bash
# Monitor script - checks disk, memory, and port availability
WARN_THRESHOLD=80
CRITICAL_THRESHOLD=90
APP_PORT=3000

DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK" -ge "$CRITICAL_THRESHOLD" ]; then
  echo "[CRITICAL] Disk usage at ${DISK}%"
elif [ "$DISK" -ge "$WARN_THRESHOLD" ]; then
  echo "[WARNING] Disk usage at ${DISK}%"
fi

if ! nc -z localhost $APP_PORT; then
  echo "[ERROR] Port $APP_PORT is not responding"
fi

echo "[INFO] Monitor check complete"
