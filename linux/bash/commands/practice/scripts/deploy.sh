#!/bin/bash
ENV="production"
echo "[INFO] Starting deployment to $ENV"
git pull origin main
npm install --production
npm run migrate
pm2 restart app --update-env
echo "[INFO] Deployment complete"
