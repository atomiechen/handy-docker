# docker build -t atomie/pytorch-tzdata-git-ssh:2.2.2-cuda11.8-cudnn8-runtime -f 2.2.2-cuda11.8-cudnn8-runtime-hdbscan-git.dockerfile ..

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

# create a new non-root user group and user
RUN groupadd -g 1000 user && \
    useradd -u 1000 -g 1000 -ms /bin/bash user && \
    echo 'PATH="/opt/conda/bin:$PATH"' >> /etc/profile.d/set_conda_path.sh

# copy assets to the user's home directory
COPY assets/ /home/user

CMD ["/usr/sbin/sshd", "-D"]
