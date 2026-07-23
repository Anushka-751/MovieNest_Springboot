#!/bin/bash

# Variables
DOCKER_USERNAME="anuu15"
DOCKER_PASSWORD="Sharmila@2004"
IMAGE_NAME="app_image"
TAG="latest"

echo "Logging in to Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

if [ $? -ne 0 ]; then
    echo "Docker login failed!"
    exit 1
fi

echo "Tagging the image..."
docker tag ${IMAGE_NAME}:${TAG} ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}

if [ $? -ne 0 ]; then
    echo "Image tagging failed!"
    exit 1
fi

echo "Pushing image to Docker Hub..."
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}

if [ $? -eq 0 ]; then
    echo "====================================="
    echo "Image pushed successfully!"
    echo "Docker Hub Image:"
    echo "${DOCKER_USERNAME}/${IMAGE_NAME}:${TAG}"
    echo "====================================="
else
    echo "Image push failed!"
    exit 1
fi
