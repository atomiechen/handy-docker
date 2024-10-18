# Handy Docker

## Images, Tags and Dockerfiles

Following images are integrated with OpenSSH server / client for remote development. They are built with UID=1000 and GID=1000 to create the non-root user.

- `python-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh)): Python image integrated with SSH. 
  - [`3.10`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10/Dockerfile)
  - [`3.10-node21`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21/Dockerfile)
  - [`3.10-node21-ffmpeg`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21-ffmpeg/Dockerfile)
  - [`3.10-node21-ffmpeg-uv0.4.18`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21-ffmpeg-uv0.4.18/Dockerfile)
- `pytorch-tzdata-git-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-git-ssh)): PyTorch integrated with SSH, tzdata and git.
  - [`2.2.2-cuda11.8-cudnn8-runtime`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/pytorch-tzdata-git-ssh/2.2.2-cuda11.8-cudnn8-runtime/Dockerfile)
  - [`2.2.2-cuda11.8-cudnn8-runtime-hdbscan`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/pytorch-tzdata-git-ssh/2.2.2-cuda11.8-cudnn8-runtime-hdbscan/Dockerfile)


<details>

<summary>(Deprecated Images)</summary>

- `python-ssh-node` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh-node)): Python + Node integrated with SSH.
- `pytorch-tzdata-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-ssh)): PyTorch integrated with SSH and tzdata.

</details>


## How to Use These Images

You can run the container with the following command, where `SALTED_PASSWD` is the salted password for the SSH user:

```sh
docker run --name my_ssh_container -e SALTED_PASSWD=my_salted_password -d atomie/python-ssh:3.10
```

But usually you want to mount the host's directory and need to make the user ID and group ID consistent between the host and the container to avoid permission issues. You can run the container with environment variables `USER_ID` and `GROUP_ID`:

```sh
docker run -d \
  --name my_ssh_container \
  -e SALTED_PASSWD=my_salted_password \
  -e USER_ID=$(id -u) \
  -e GROUP_ID=$(id -g) \
  -v /path/to/host/dir:/path/to/container/dir \
  atomie/python-ssh:3.10
```

## Generate Salted Password

> [!NOTE]
> You can use `gen_salted_passwd.sh` to generate the salted password file interactively.

The encrypted password is generated with salt:

```sh
CLEAR_PASSWD="clear_text_password"
SALTED_PASSWD=$(printf $CLEAR_PASSWD | openssl passwd -6 -salt KdN5Re3X2X18 -stdin)
echo $SALTED_PASSWD > salted_passwd
```

## Docker Secrets

As an alternative to passing the salted password as an environment variable, you can use Docker secrets to store the salted password in a file and mount it to the container. 

```sh
docker secret create salted_passwd salted_passwd
```

Then you can run the container by specifying the secret file path to the environment variable `SALTED_PASSWD_FILE`:

```sh
docker run -d \
  --name my_ssh_container \
  --secret salted_passwd \
  -e SALTED_PASSWD_FILE=/run/secrets/salted_passwd \
  atomie/python-ssh:3.10
```


## Handy scripts

Scripts in `scripts` directory:

- `start_docker.sh`: script for (re)starting a container with SSH-integration. 
- `start_super_docker.sh`: script for further sharing the host's docker socket and binary with the container.
- `gen_salted_passwd.sh`: interactive script for generating the salted password to a file.
