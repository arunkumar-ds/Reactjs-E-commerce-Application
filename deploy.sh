#!/bin/bash
# Usage: ./deploy.sh <full_image_name>
export IMAGE_NAME=$1

# Force pull the specific image and restart
docker-compose down || true
docker-compose pull
docker-compose up -d
