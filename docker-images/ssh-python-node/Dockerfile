# local build:
# docker build -t atomie/ssh-python-node:3.10-node24 .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 --push -t atomie/ssh-python-node:3.10-node24 .

ARG PYTHON_VERSION=3.10

FROM atomie/ssh-python:${PYTHON_VERSION}

ARG NODE_VERSION=24

# install Node.js using NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    # smoke tests
    node --version && \
    npm --version && \
    corepack --version

# enable corepack and install pnpm and yarn
# use global corepack home instead of user home to share the cache between users
ENV COREPACK_HOME=/opt/corepack

# set default versions for pnpm and yarn, can be overridden at build time
ARG PNPM_VERSION=10.30.3
ARG YARN_VERSION=1.22.22

RUN mkdir -p ${COREPACK_HOME} && \
    chmod 777 ${COREPACK_HOME} && \
    corepack enable && \
    corepack prepare pnpm@${PNPM_VERSION} --activate && \
    corepack prepare yarn@${YARN_VERSION} --activate && \
    # smoke tests
    yarn --version && \
    pnpm --version
