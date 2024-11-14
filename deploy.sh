#!/bin/bash

# ./deploy.sh vm1
REMOTE_HOST=$1

# Define variables
HOST_CURRENT_DIR="/home/alexandru/Java/consumer"
REMOTE_CURRENT_DIR="/home/alexandru/Java/consumer"
REMOTE_USER="alexandru"
DOCKER_IMAGE_NAME="kafka-consumer:1.0"
DOCKER_CONTAINER_NAME="kafka-consumer"

REMOTE_COMMAND="ls -l /home/$REMOTE_USER"

cd ${HOST_CURRENT_DIR}
scp -r . ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_CURRENT_DIR} 2> deploy_errors

echo "Building image ${DOCKER_IMAGE_NAME}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "docker buildx build --load -t ${DOCKER_IMAGE_NAME} ${REMOTE_CURRENT_DIR}"
echo "Cleaning containers"
ssh ${REMOTE_USER}@${REMOTE_HOST} "docker rm -f ${DOCKER_CONTAINER_NAME}"
echo "Starting container"
ssh ${REMOTE_USER}@${REMOTE_HOST} "docker run -d -p 8080:8080 -p 9092:9092 --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME}"
