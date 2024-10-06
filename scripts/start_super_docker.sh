#!/bin/bash

# (Re)start a docker container with SSH service running
# prerequisites:
# - A salted password file
# - (optional) A directory with SSH keys to be mounted as ~/.ssh (public and private keys, authorized_keys, etc.) 
#   for preserving identity and login access

## Configuration
# salted password file
SALTED_PASSWD_FILE=pass
# SSH key directory to be mounted to container, empty if not needed
SSH_KEY_DIR=$(pwd)/ssh-keys
# image to run
IMAGE=atomie/python-ssh-node:py3.10-node21
# container name
CONTAINER_NAME=my_container
# port on host machine for SSH forwarding
SSH_PORT=22
# extra flags for docker run (volume mounts, ports, GPU, time zone, etc.)
EXTRA_FLAGS="-e TZ=Asia/Shanghai"
# host docker group name, for sharing docker socket and permissions
DOCKER_GROUP_NAME=docker


# check prerequisites
if [ ! -f $SALTED_PASSWD_FILE ]; then
    echo "Salted password file not found: $SALTED_PASSWD_FILE"
    exit 1
fi
if [ ! -d $SSH_KEY_DIR ]; then
    echo "SSH key directory not found: $SSH_KEY_DIR"
    SSH_VOLUME_MOUNTS=""
else
    SSH_VOLUME_MOUNTS="-v $SSH_KEY_DIR:/home/user/.ssh"
fi


# stop and remove container
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# get host docker group id
DOCKER_GROUP_ID=$(getent group $DOCKER_GROUP_NAME | cut -d: -f3)

# change the uid and gid of user in docker, add user to docker group,
# and then start SSH service
docker run -d -it \
    --name $CONTAINER_NAME \
    --user root \
    --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/bin/docker:/usr/bin/docker \
    -p $SSH_PORT:22 \
    $SSH_VOLUME_MOUNTS \
    $EXTRA_FLAGS \
    $IMAGE \
    bash -c "usermod -u $(id -u) user && groupmod -g $(id -g) user && \
        groupadd -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME && usermod -aG $DOCKER_GROUP_NAME user && \
        echo '$(cat $SALTED_PASSWD_FILE)' | chpasswd --encrypted && /usr/sbin/sshd -D"
