set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=jankar

VERSION=$1

# image name
IMAGE=brother-brscan4
docker build -t $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$VERSION --build-arg VERSION=$VERSION .
