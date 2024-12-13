#!/bin/bash

# Log in to Docker Hub
echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Build the Docker image
docker build -t "$DOCKER_USERNAME/envsubst:1.0" .

# Push the Docker image
docker push "$DOCKER_USERNAME/envsubst:1.0"
