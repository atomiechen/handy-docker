# Handy Docker

## Images, Tags and Dockerfiles

Following images are integrated with OpenSSH server / client for remote development. They are built with UID=1000 and GID=1000 to create the non-root user.

- `ssh-python` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/ssh-python), [GHCR](https://github.com/atomiechen/handy-docker/pkgs/container/ssh-python), [Dockerfile](https://github.com/atomiechen/handy-docker/blob/main/docker-images/ssh-python/Dockerfile)): Python image integrated with SSH.
  - `3.10`, `3.11`, `3.12`
- `ssh-python-node` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/ssh-python-node), [GHCR](https://github.com/atomiechen/handy-docker/pkgs/container/ssh-python-node), [Dockerfile](https://github.com/atomiechen/handy-docker/blob/main/docker-images/ssh-python-node/Dockerfile)): Python + Node integrated with SSH.
  - `3.10-node24`, `3.11-node24`, `3.12-node24`
- `ssh-python-node-ffmpeg` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/ssh-python-node-ffmpeg), [GHCR](https://github.com/atomiechen/handy-docker/pkgs/container/ssh-python-node-ffmpeg), [Dockerfile](https://github.com/atomiechen/handy-docker/blob/main/docker-images/ssh-python-node-ffmpeg/Dockerfile)): Python + Node + FFmpeg integrated with SSH.
  - `3.10-node24`, `3.11-node24`, `3.12-node24`
- `pytorch-tzdata-git-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-git-ssh), [GHCR](https://github.com/atomiechen/handy-docker/pkgs/container/pytorch-tzdata-git-ssh)): PyTorch integrated with SSH, tzdata and git.
  - [`2.2.2-cuda11.8-cudnn8-runtime`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/pytorch-tzdata-git-ssh/2.2.2-cuda11.8-cudnn8-runtime/Dockerfile)
  - [`2.2.2-cuda11.8-cudnn8-runtime-hdbscan`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/pytorch-tzdata-git-ssh/2.2.2-cuda11.8-cudnn8-runtime-hdbscan/Dockerfile)


<details>

<summary>(Deprecated Images)</summary>

- `python-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh), [GHCR](https://github.com/atomiechen/handy-docker/pkgs/container/python-ssh)): Python image integrated with SSH. 
  - [`3.10`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10/Dockerfile)
  - [`3.10-node21`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21/Dockerfile)
  - [`3.10-node21-ffmpeg`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21-ffmpeg/Dockerfile)
  - [`3.10-node21-ffmpeg-uv0.4.18`](https://github.com/atomiechen/handy-docker/blob/main/docker-images/python-ssh/3.10-node21-ffmpeg-uv0.4.18/Dockerfile)
- `python-ssh-node` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/python-ssh-node)): Python + Node integrated with SSH.
- `pytorch-tzdata-ssh` ([Docker Hub](https://hub.docker.com/repository/docker/atomie/pytorch-tzdata-ssh)): PyTorch integrated with SSH and tzdata.

</details>


## How to Use These Images

Password authentication is disabled by default. Mount an `authorized_keys` file to use public-key authentication:

```sh
docker run -d \
  --name my_ssh_container \
  -v ./ssh-keys:/home/user/.ssh \
  atomie/ssh-python:3.10
```

But usually you want to mount the host's directory and need to make the user ID and group ID consistent between the host and the container to avoid permission issues. You can run the container with environment variables `USER_ID` and `GROUP_ID`:

```sh
docker run -d \
  --name my_ssh_container \
  -e USER_ID=$(id -u) \
  -e GROUP_ID=$(id -g) \
  -v ./ssh-keys:/home/user/.ssh \
  -v /path/to/host/dir:/path/to/container/dir \
  atomie/ssh-python:3.10
```

When a non-empty salted password is supplied through `SALTED_PASSWD_FILE` or the legacy `SALTED_PASSWD` environment variable, the image sets the `user` password and enables password authentication. Without one, it explicitly starts OpenSSH with `PasswordAuthentication=no`.

## Generate Salted Password

> [!NOTE]
> You can use `gen_salted_passwd.sh` to generate the salted password file interactively.

Generate a salted password hash without storing the clear-text password in shell history:

```sh
read -rsp "Password: " CLEAR_PASSWD
printf '\n'
printf '%s' "$CLEAR_PASSWD" | openssl passwd -6 -stdin > salted_passwd
unset CLEAR_PASSWD
chmod 600 salted_passwd
```

## Docker Secrets

Prefer a Compose secret over `SALTED_PASSWD`, because environment variables are visible through `docker inspect`:

```yaml
services:
  ssh:
    image: atomie/ssh-python:3.10
    environment:
      SALTED_PASSWD_FILE: /run/secrets/salted_passwd
    secrets:
      - salted_passwd

secrets:
  salted_passwd:
    file: ./salted_passwd
```

`SALTED_PASSWD` remains supported for compatibility, but should not be used for new deployments.


## Handy scripts

Scripts in `scripts` directory:

- `start_docker.sh`: script for (re)starting a container with SSH-integration. 
- `start_super_docker.sh`: script for further sharing the host's docker socket and binary with the container.
- `gen_salted_passwd.sh`: interactive script for generating the salted password to a file.
