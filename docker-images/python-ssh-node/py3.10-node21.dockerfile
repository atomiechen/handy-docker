# docker build -t atomie/python-ssh-node:py3.10-node21 .

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
    yarn --version
