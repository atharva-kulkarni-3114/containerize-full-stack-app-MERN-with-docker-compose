#!/bin/bash
# setup-env.sh - DevOps Environment Verification Script

echo "========================================="
echo "  DevOps Environment Setup Checker"
echo "========================================="
echo ""

# Check Docker
echo "[1/3] Checking Docker..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "✓ Docker installed: $DOCKER_VERSION"
else
    echo "✗ Docker NOT found"
    echo "  Install with: sudo apt install docker.io -y"
    exit 1
fi

# Check Docker Compose
echo ""
echo "[2/3] Checking Docker Compose..."
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo "✓ Docker Compose installed: $COMPOSE_VERSION"
else
    echo "✗ Docker Compose NOT found"
    echo "  Install from: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check Git
echo ""
echo "[3/3] Checking Git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo "✓ Git installed: $GIT_VERSION"
else
    echo "✗ Git NOT found"
    echo "  Install with: sudo apt install git -y"
    exit 1
fi

echo ""
echo "========================================="
echo "✓ All tools verified! Ready for DevOps."
echo "========================================="

