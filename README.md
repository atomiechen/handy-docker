# Handy Docker

## Images, Tags and Dockerfiles

Images integrated with OpenSSH server / client for remote development. 

- `python-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh)): Python image integrated with SSH. 
  - [`3.10`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10/Dockerfile)
  - [`3.10-node21`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21/Dockerfile)
  - [`3.10-node21-ffmpeg`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21-ffmpeg/Dockerfile)
- `pytorch-tzdata-git-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-git-ssh)): PyTorch integrated with SSH, tzdata and git.
  - [`2.2.2-cuda11.8-cudnn8-runtime`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/pytorch-tzdata-git-ssh/2.2.2-cuda11.8-cudnn8-runtime/Dockerfile)
  - [`2.2.2-cuda11.8-cudnn8-runtime-hdbscan`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/pytorch-tzdata-git-ssh/2.2.2-cuda11.8-cudnn8-runtime-hdbscan/Dockerfile)


<details>

<summary>Deprecated Images</summary>

- `python-ssh-node` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh-node)): Python + Node integrated with SSH.
- `pytorch-tzdata-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-ssh)): PyTorch integrated with SSH and tzdata.

</details>


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

> [!NOTE]
> You can use `gen_salted_pass.sh` to generate the salted password file interactively.

## Handy scripts

Scripts in `scripts` directory:

- `start_docker.sh`: script for (re)starting a container with SSH-integration. 
- `start_super_docker.sh`: script for further sharing the host's docker socket and binary with the container.
- `gen_salted_pass.sh`: interactive script for generating the salted password to a file.
