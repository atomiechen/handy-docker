#!/bin/bash

# (Re)start a docker container with SSH service running
# prerequisites:
# - A salted password file
# - (optional) A directory with SSH keys to be mounted as ~/.ssh (public and private keys, authorized_keys, etc.) 
#   for preserving identity and login access

## Configuration
# salted password file
SALTED_PASSWD_FILE=./salted_passwd
# SSH key directory to be mounted to container, empty if not needed
SSH_KEY_DIR=./ssh-keys
# image to run
IMAGE=atomie/python-ssh:3.10
# container name
CONTAINER_NAME=my_ssh_container
# port on host machine for SSH forwarding
SSH_PORT=22
# extra flags for docker run (volume mounts, ports, GPU, time zone, etc.)
EXTRA_FLAGS="-e TZ=Asia/Shanghai"

# check prerequisites
if [ ! -f $SALTED_PASSWD_FILE ]; then
    echo "Salted password file not found: $SALTED_PASSWD_FILE"
    exit 1
fi
if [ ! -d $SSH_KEY_DIR ]; then
    echo "Skipped mount: SSH key directory not found: $SSH_KEY_DIR"
    SSH_VOLUME_MOUNTS=""
else
    SSH_VOLUME_MOUNTS="-v $SSH_KEY_DIR:/home/user/.ssh"
fi


# stop and remove container
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# change the uid and gid of user in docker, and then start SSH service
docker run -d -it \
    --name $CONTAINER_NAME \
    --restart always \
    -p $SSH_PORT:22 \
    -e USER_ID=$(id -u) \
    -e GROUP_ID=$(id -g) \
    -e SALTED_PASSWD=$(cat $SALTED_PASSWD_FILE) \
    $SSH_VOLUME_MOUNTS \
    $EXTRA_FLAGS \
    $IMAGE
