# local build:
# docker build -t atomie/ssh-python:3.10 .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 --push -t atomie/ssh-python:3.10 .

ARG PYTHON_VERSION=3.10

FROM python:${PYTHON_VERSION}

# install uv
# ref: https://docs.astral.sh/uv/guides/integration/docker/#installing-uv
COPY --from=ghcr.io/astral-sh/uv:0.10.8 /uv /uvx /bin/

# install ssh with OpenSSH server and client
# remove LANG and LC_* from AcceptEnv in sshd_config to prevent locale issues in SSH sessions
# persist LANG in /etc/environment as SSH sessions don't inherit Docker ENV
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ssh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd && \
    sed -i -E '/^AcceptEnv/s/\s*(LANG|LC_\S*)//g; /^AcceptEnv\s*$/d; /^AcceptEnv/s/\s+/ /g' /etc/ssh/sshd_config && \
    printf "LANG=%s\n" "$LANG" >> /etc/environment
    # echo >> /etc/ssh/sshd_config && \
    # echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# set default environment variables
ENV GROUP_ID=1000
ENV USER_ID=1000

# create a new non-root user group and user
RUN groupadd -g ${GROUP_ID} user && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -ms /bin/bash user

# copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

# copy assets to the user's home directory
COPY assets/ /home/user

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e"]
