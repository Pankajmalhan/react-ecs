#!/bin/bash
# echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
# docker build -t react-app .
# docker tag react-app:latest 806107407018.dkr.ecr.ap-south-1.amazonaws.com/react-app:latest
# docker push 806107407018.dkr.ecr.ap-south-1.amazonaws.com/react-app:latest


#!/bin/bash -e

# the registry should have been created already
# you could just paste a given url from AWS but I'm
# parameterising it to make it more obvious how its constructed
pip install --user awscli
export PATH=$PATH:$HOME/.local/bin

# install necessary dependency for ecs-deploy
add-apt-repository ppa:eugenesan/ppa
apt-get update
apt-get install jq -y

# install ecs-deploy
curl https://raw.githubusercontent.com/silinternational/ecs-deploy/master/ecs-deploy | \
  sudo tee -a /usr/bin/ecs-deploy
sudo chmod +x /usr/bin/ecs-deploy

$(aws ecr get-login --no-include-email --region ap-south-1)

REGISTRY_URL=806107407018.dkr.ecr.ap-south-1.amazonaws.com
# this is most likely namespaced repo name like myorg/veryimportantimage
SOURCE_IMAGE="react-app"
SOURCE_IMAGE_LATEST="${SOURCE_IMAGE}:latest"
# using it as there will be 2 versions published
TARGET_IMAGE="${REGISTRY_URL}/react-app"
# lets make sure we always have access to latest image
TARGET_IMAGE_LATEST="${TARGET_IMAGE}:latest"

echo "$TARGET_IMAGE_LATEST"

TIMESTAMP=$(date '+%Y%m%d%H%M%S')
# using datetime as part of a version for versioned image
VERSION="${TIMESTAMP}-${TRAVIS_COMMIT}"
# using specific version as well
# it is useful if you want to reference this particular version
# in additional commands like deployment of new Elasticbeanstalk version

# making sure correct region is set

# Push image to ECR
###################

# I'm speculating it obtains temporary access token
# it expects aws access key and secret set
# in environmental vars
# eval $(aws ecr get-login --no-include-email)

# update latest version
docker build -t ${SOURCE_IMAGE_LATEST} .
docker tag ${SOURCE_IMAGE_LATEST} ${TARGET_IMAGE_LATEST}
docker push ${TARGET_IMAGE_LATEST}
#aws ecs stop-task --cluster react-cluster --task 226698f6-0315-47ea-9443-b0f2cacf563f
# aws ecs update-service --region ap-south-1 --cluster react-cluster --service react-container-service  --task-definition first-run-task-definition
# aws ecs update-service --force-new-deployment --service react-container-service  
# aws ecs stop-task --cluster react-cluster --task a2f3a67a-2dd8-4128-beba-61b457b030f0

#ecs-deploy -c react-cluster -n react-container-service -i 806107407018.dkr.ecr.ap-south-1.amazonaws.com/react-app:latest
#aws ecs update-service  --cluster react-cluster --service react-container-service --task-definition first-run-task-definition --desired-count 1

CLIENT/bin/ecs-deploy.sh -c react-cluster -n react-container-service -i 806107407018.dkr.ecr.ap-south-1.amazonaws.com/react-app:latest -r ap-south-1 -t 240