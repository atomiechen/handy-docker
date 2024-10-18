# local build:
# docker build -t atomie/python-ssh:3.10 .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 --push -t atomie/python-ssh:3.10 .

FROM python:3.10

# install ssh
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ssh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /run/sshd
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

CMD ["/usr/sbin/sshd", "-D"]
