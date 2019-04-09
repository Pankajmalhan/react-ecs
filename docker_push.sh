#!/bin/bash
# echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
# docker build -t react-app .
# docker tag react-app:latest 806107407018.dkr.ecr.ap-south-1.amazonaws.com/react-app:latest
# docker push 806107407018.dkr.ecr.ap-south-1.amazonaws.com/react-app:latest


#!/bin/bash -e

# the registry should have been created already
# you could just paste a given url from AWS but I'm
# parameterising it to make it more obvious how its constructed
REGISTRY_URL=806107407018.dkr.ecr.ap-south-1.amazonaws.com
# this is most likely namespaced repo name like myorg/veryimportantimage
SOURCE_IMAGE="react-app"
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
aws configure set default.region ap-south-1

# Push image to ECR
###################

# I'm speculating it obtains temporary access token
# it expects aws access key and secret set
# in environmental vars
$(aws ecr get-login --no-include-email)

# update latest version
docker tag ${SOURCE_IMAGE} ${TARGET_IMAGE_LATEST}
docker push ${TARGET_IMAGE_LATEST}
