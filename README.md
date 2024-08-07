# Handy Docker

## Image List

Images integrated with SSH for remote development. 

- `python-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh)): Python image integrated with SSH. 
- `python-ssh-node` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh-node)): Python + Node integrated with SSH.
- `pytorch-tzdata-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-ssh)): PyTorch integrated with SSH and tzdata.
- `pytorch-tzdata-git-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-git-ssh)): PyTorch integrated with SSH, tzdata and git.


## Build

Images are built with UID=1000 and GID=1000 to create the non-root user.

## Run

However, you can (and you should) change UID and GID to match the host machine's UID and GID using `usermod` and `groupmod`. Also you need to set a password. For example:
```sh
docker run -d -it --user root $IMAGE \
    bash -c "usermod -u $(id -u) user && groupmod -g $(id -g) user && echo '$(cat pass)' | chpasswd --encrypted && /usr/sbin/sshd -D"
```
Here the file `pass` stores the encrypted password, which is generated with salt (`USER` is the username in the container):
```sh
USER=user
CLEAR_PASSWORD="clear_text_password"
SALTED=$(printf $CLEAR_PASSWORD | openssl passwd -6 -salt KdN5Re3X2X18 -stdin)
echo $USER:$SALTED > pass
```

## Handy scripts

- `start_docker.sh`: script for (re)starting a container with SSH-integration. 

