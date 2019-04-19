!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
docker build -t pankajchoudhary/multi-client .
docker push pankajchoudhary/multi-client