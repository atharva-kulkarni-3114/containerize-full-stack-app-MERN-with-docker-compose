#!/bin/bash
# health-check.sh - Container and Application Health Monitor

echo "========================================="
echo "  Docker Application Health Check"
echo "========================================="
echo ""

# Check if Docker is running
echo "[Step 1] Checking Docker daemon..."
if ! docker info &> /dev/null; then
    echo "✗ Docker daemon is NOT running"
    echo "  Start with: sudo systemctl start docker"
    exit 1
fi
echo "✓ Docker daemon is running"

# Check container status
echo ""
echo "[Step 2] Checking container status..."
CONTAINERS=$(docker-compose ps --services 2>/dev/null)

if [ -z "$CONTAINERS" ]; then
    echo "✗ No containers found. Run 'docker-compose up -d' first"
    exit 1
fi

echo "Checking individual containers:"
for container in $CONTAINERS; do
    STATUS=$(docker-compose ps -q $container 2>/dev/null | xargs docker inspect -f '{{.State.Status}}' 2>/dev/null)
    
    if [ "$STATUS" == "running" ]; then
        echo "  ✓ $container: Running"
    else
        echo "  ✗ $container: $STATUS (NOT running)"
    fi
done

# Check application endpoints
echo ""
echo "[Step 3] Checking application endpoints..."

# Check backend API
if curl -s http://localhost:5000/user &> /dev/null; then
    echo "  ✓ Backend API (port 5000): Responding"
else
    echo "  ✗ Backend API (port 5000): Not responding"
fi

# Check frontend
if curl -s http://localhost:80 &> /dev/null; then
    echo "  ✓ Frontend (port 80): Responding"
else
    echo "  ✗ Frontend (port 80): Not responding"
fi

# Check MongoDB
if docker exec $(docker-compose ps -q mongodb) mongosh --eval "db.adminCommand('ping')" &> /dev/null; then
    echo "  ✓ MongoDB: Responding to queries"
else
    echo "  ✗ MongoDB: Not responding"
fi

echo ""
echo "========================================="
echo "Health check complete!"
echo "========================================="
