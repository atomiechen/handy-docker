# docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t atomie/python-ssh:3.10 .

FROM python:3.10

# install ssh
RUN apt-get update && \
    apt-get install -y ssh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /run/sshd
    # echo >> /etc/ssh/sshd_config && \
    # echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

ARG USER_ID
ARG GROUP_ID

# create a new non-root user group and user
RUN groupadd -g $GROUP_ID user && \
    useradd -u $USER_ID -g $GROUP_ID -ms /bin/bash user

CMD ["/usr/sbin/sshd", "-D"]
