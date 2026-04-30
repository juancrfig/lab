#!/bin/bash
echo "Deploying to production..."
git pull origin main
npm install --production
pm2 restart app
echo "Deploy complete."
