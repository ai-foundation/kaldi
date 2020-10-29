#! /bin/bash

# create TAG_PREFIX from ECR if TAG_LOCAL was defined #
if [ -n "$TAG_LOCAL" ]; then TAG_PREFIX="${TAG_LOCAL}_"; fi
CIRCLE_BRANCH_TRANSFORMED="$(echo $CIRCLE_BRANCH | tr ['/'] '-')"
CIRCLE_SHA1_SHORT="$(echo $CIRCLE_SHA1 | cut -c -7)"

# push a specific tagged version to permanently reference this image #
IMAGE_TAG="${TAG_PREFIX}${CIRCLE_BRANCH_TRANSFORMED}_${CIRCLE_SHA1_SHORT}_${CIRCLE_BUILD_NUM}"
docker tag "${TAG_LOCAL:-$ECR_REPO}:latest" "${AMAZON_ECR}/${ECR_REPO}:${IMAGE_TAG}"
docker push "${AMAZON_ECR}/${ECR_REPO}:${IMAGE_TAG}"

# tag the latest build of the branch #
docker tag "${TAG_LOCAL:-$ECR_REPO}:latest" "${AMAZON_ECR}/${ECR_REPO}:${TAG_PREFIX}${CIRCLE_BRANCH_TRANSFORMED}_latest"
docker push "${AMAZON_ECR}/${ECR_REPO}:${TAG_PREFIX}${CIRCLE_BRANCH_TRANSFORMED}_latest"

# update the latest if it's a dev/master branch build #
# NOTE: production tag is done by intentional promotion #
if [ "$CIRCLE_BRANCH" == "dev" -o "$CIRCLE_BRANCH" == "master" ]
then
    docker tag "${TAG_LOCAL:-$ECR_REPO}:latest" "${AMAZON_ECR}/${ECR_REPO}:${TAG_PREFIX}latest"
    docker push "${AMAZON_ECR}/${ECR_REPO}:${TAG_PREFIX}latest"
fi
