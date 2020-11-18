set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=jankar

# image name
IMAGE=brother-brscan4
docker build -t $USERNAME/$IMAGE:latest .
