#!bin/bash 
echo "Building image for project"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stn

docker build -t $DOCKER_USERNAME/ci-cd-pipeline ../backend/Dockerfile
docker build -t $DOCKER_USERNAME/ci-cd-pipeline ../dive-react-app/Dockerfile

docker push $DOCKER_USERNAME/ci-cd-backend-pipeline:v1
docker push $DOCKER_USERNAME/ci-cd-frontend-pipeline:v1



