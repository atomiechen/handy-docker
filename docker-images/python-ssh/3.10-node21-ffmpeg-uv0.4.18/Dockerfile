# local build:
# docker build -t atomie/python-ssh:3.10-node21-ffmpeg-uv0.4.18 .
# multi-arch build and push:
# docker buildx build --platform linux/amd64,linux/arm64 -t atomie/python-ssh:3.10-node21-ffmpeg-uv0.4.18 -f Dockerfile --push .

FROM atomie/python-ssh:3.10-node21-ffmpeg

# install uv
# ref: https://docs.astral.sh/uv/guides/integration/docker/#installing-uv
COPY --from=ghcr.io/astral-sh/uv:0.4.18 /uv /bin/uv
