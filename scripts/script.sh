#!/bin/bash
echo "Pulling docker image for deployment"

docker pull $DOCKER_USERNAME/wtf-backend
docker pull $DOCKER_USERNAME/wtf-frontend

echo "restarting containers"
docker-compose down || true
docker-compose up -d --force-recreate

echo "deployment successful"
