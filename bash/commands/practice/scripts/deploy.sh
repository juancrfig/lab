#!/bin/bash
set -e

ENV=${1:-staging}
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "unknown")
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "[INFO] Deploying version $VERSION to $ENV at $TIMESTAMP"

git pull origin main
npm ci --production
npm run migrate

if pm2 list | grep -q "app"; then
    pm2 restart app --update-env
else
    pm2 start app.js --name app
fi

echo "[INFO] Deployment complete"
