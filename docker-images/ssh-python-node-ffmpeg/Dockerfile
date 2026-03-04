# local build:
# docker build -t atomie/ssh-python-node-ffmpeg:3.10-node24 .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 --push -t atomie/ssh-python-node-ffmpeg:3.10-node24 .

ARG PYTHON_VERSION=3.10
ARG NODE_VERSION=24

FROM atomie/ssh-python-node:${PYTHON_VERSION}-node${NODE_VERSION}

# install ffmpeg
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*
