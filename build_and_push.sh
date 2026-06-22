#!/bin/sh

set -e

IMAGE_NAME="bjing/dev-container-base"
DATE_TAG="$(date +%Y-%m-%d)"

docker build \
  -t "${IMAGE_NAME}:${DATE_TAG}" \
  -t "${IMAGE_NAME}:latest" \
  .

docker push "${IMAGE_NAME}:${DATE_TAG}"
docker push "${IMAGE_NAME}:latest"
