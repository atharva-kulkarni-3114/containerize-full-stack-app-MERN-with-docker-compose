#!/bin/bash
# deploy.sh - Automated Deployment Script

echo "========================================="
echo "  Starting Automated Deployment"
echo "========================================="
echo ""

# Step 1: Pull latest code
echo "[1/5] Pulling latest code from Git..."
git pull origin main
if [ $? -ne 0 ]; then
    echo "✗ Git pull failed. Check your repository."
    exit 1
fi
echo "✓ Code updated"

# Step 2: Stop old containers
echo ""
echo "[2/5] Stopping old containers..."
docker-compose down
echo "✓ Old containers stopped"

# Step 3: Rebuild images
echo ""
echo "[3/5] Rebuilding Docker images..."
docker-compose build --no-cache
if [ $? -ne 0 ]; then
    echo "✗ Build failed. Check Dockerfiles."
    exit 1
fi
echo "✓ Images rebuilt"

# Step 4: Start new containers
echo ""
echo "[4/5] Starting new containers..."
docker-compose up -d
if [ $? -ne 0 ]; then
    echo "✗ Container startup failed."
    exit 1
fi
echo "✓ Containers started"

# Step 5: Wait and run health check
echo ""
echo "[5/5] Waiting 15 seconds for services to initialize..."
sleep 15

echo "Running health check..."
./health-check.sh

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "✓ Deployment successful!"
    echo "========================================="
else
    echo ""
    echo "========================================="
    echo "✗ Deployment failed health check"
    echo "========================================="
    exit 1
fi
