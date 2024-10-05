# docker build -t atomie/python-ssh:3.10 -f Dockerfile ../..

FROM python:3.10

# install ssh
RUN apt-get update && \
    apt-get install -y ssh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /run/sshd
    # echo >> /etc/ssh/sshd_config && \
    # echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# create a new non-root user group and user
RUN groupadd -g 1000 user && \
    useradd -u 1000 -g 1000 -ms /bin/bash user

# copy assets to the user's home directory
COPY assets/ /home/user

CMD ["/usr/sbin/sshd", "-D"]
