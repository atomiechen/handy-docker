# local build:
# docker build -t atomie/python-ssh:3.10-node21 .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 --push -t atomie/python-ssh:3.10-node21 .

FROM atomie/python-ssh:3.10

# install Node.js and Yarn
# using NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y nodejs && \
    # npm install --global yarn && \
    corepack enable && \
    rm -rf /var/lib/apt/lists/* && \
    # smoke tests
    node --version && \
    npm --version && \
    corepack --version && \
    yarn --version && \
    pnpm --version
