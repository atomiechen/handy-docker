# docker build -t atomie/python-ssh-node:py3.10-node21-ffmpeg -f py3.10-node21-ffmpeg.dockerfile .

FROM atomie/python-ssh-node:py3.10-node21

# install ffmpeg
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*
