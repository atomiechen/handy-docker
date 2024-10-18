# local build:
# docker build -t atomie/python-ssh:3.10-node21-ffmpeg .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 --push -t atomie/python-ssh:3.10-node21-ffmpeg .

FROM atomie/python-ssh:3.10-node21

# install ffmpeg
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ffmpeg && \
    rm -rf /var/lib/apt/lists/*
