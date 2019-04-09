#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
docker push 806107407018.dkr.ecr.ap-south-1.amazonaws.com/react-app:latest