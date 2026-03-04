# local build:
# docker build -t atomie/ssh-python-node:3.10-node24 .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 --push -t atomie/ssh-python-node:3.10-node24 .

ARG PYTHON_VERSION=3.10
ARG NODE_VERSION=24

FROM atomie/ssh-python:${PYTHON_VERSION}

# install Node.js using NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    corepack enable && \
    # smoke tests
    node --version && \
    npm --version && \
    corepack --version && \
    yarn --version && \
    pnpm --version
