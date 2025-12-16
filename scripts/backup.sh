#!/bin/bash
# backup.sh - MongoDB Backup Script

BACKUP_DIR="../backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/mongo_backup_$TIMESTAMP.archive"

echo "========================================="
echo "  MongoDB Backup Script"
echo "========================================="
echo ""

# Create backup directory
mkdir -p $BACKUP_DIR

# Run backup
echo "Creating backup..."
docker-compose exec -T mongodb mongodump --archive > $BACKUP_FILE

if [ $? -eq 0 ]; then
    SIZE=$(du -h $BACKUP_FILE | cut -f1)
    echo "✓ Backup successful!"
    echo "  File: $BACKUP_FILE"
    echo "  Size: $SIZE"
else
    echo "✗ Backup failed"
    exit 1
fi

echo ""
echo "========================================="
echo "Backup complete!"
echo "========================================="
