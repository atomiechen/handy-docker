# docker build -t atomie/pytorch-tzdata-ssh:2.2.2-cuda11.8-cudnn8-runtime .

FROM pytorch/pytorch:2.2.2-cuda11.8-cudnn8-runtime

# install tzdata and ssh
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    apt-get install -y ssh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /run/sshd
    # echo >> /etc/ssh/sshd_config && \
    # echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

ARG USER_ID
ARG GROUP_ID

# create a new non-root user group and user
RUN groupadd -g 1000 user && \
    useradd -u 1000 -g 1000 -ms /bin/bash user && \
    echo 'PATH="/opt/conda/bin:$PATH"' >> /etc/profile.d/set_conda_path.sh

CMD ["/usr/sbin/sshd", "-D"]
