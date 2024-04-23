set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=jankar

VERSION=$1

# image name
IMAGE=brscan-skey
docker build -t $USERNAME/$IMAGE:latest --build-arg VERSION=$VERSION .
