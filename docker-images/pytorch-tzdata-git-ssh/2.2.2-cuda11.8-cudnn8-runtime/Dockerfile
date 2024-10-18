# docker build --platform linux/amd64 --push -t atomie/pytorch-tzdata-git-ssh:2.2.2-cuda11.8-cudnn8-runtime .

FROM pytorch/pytorch:2.2.2-cuda11.8-cudnn8-runtime

# install tzdata, git and ssh
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    apt-get install -y git && \
    apt-get install -y ssh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /run/sshd
    # echo >> /etc/ssh/sshd_config && \
    # echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# set default environment variables
ENV GROUP_ID=1000
ENV USER_ID=1000

# create a new non-root user group and user
RUN groupadd -g ${GROUP_ID} user && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -ms /bin/bash user && \
    echo 'PATH="/opt/conda/bin:$PATH"' >> /etc/profile.d/set_conda_path.sh

# copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

# copy assets to the user's home directory
COPY assets/ /home/user

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
