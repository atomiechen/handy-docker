variable "dockerhub" {
  default = "atomie"
}

variable "ghcr" {
  default = "ghcr.io/atomiechen"
}

variable "python_versions" {
  default = ["3.10", "3.11", "3.12"]
}

variable "node_versions" {
  default = ["24"]
}

variable "pnpm_version" {
  default = "10.30.3"
}

variable "yarn_version" {
  default = "1.22.22"
}

group "default" {
  targets = [
    "ssh-python",
    "ssh-python-node",
    "ssh-python-node-ffmpeg",
  ]
}

target "base" {
  platforms = ["linux/amd64", "linux/arm64"]
  pull = true
  attest = [
    { type = "provenance", mode = "max" },
    { type = "sbom" },
  ]
}

target "ssh-python" {
  name = "ssh-python${replace(python, ".", "_")}"
  inherits = ["base"]

  context = "docker-images/ssh-python"
  dockerfile = "Dockerfile"

  matrix = {
    python = python_versions
  }

  args = {
    PYTHON_VERSION = "${python}"
  }

  tags = [
    "${dockerhub}/ssh-python:${python}",
    "${ghcr}/ssh-python:${python}",
  ]

  cache-from = [{ type = "gha", scope = "ssh-python-${python}" }]
  cache-to   = [{ type = "gha", scope = "ssh-python-${python}", mode = "max" }]
}

target "ssh-python-node" {
  name = "ssh-python${replace(python, ".", "_")}-node${node}"
  inherits = ["base"]

  context = "docker-images/ssh-python-node"
  dockerfile = "Dockerfile"

  matrix = {
    python = python_versions
    node   = node_versions
  }

  args = {
    PYTHON_VERSION = "${python}"
    NODE_VERSION   = "${node}"
    PNPM_VERSION   = "${pnpm_version}"
    YARN_VERSION   = "${yarn_version}"
  }

  tags = [
    "${dockerhub}/ssh-python-node:${python}-node${node}",
    "${ghcr}/ssh-python-node:${python}-node${node}",
  ]

  cache-from = [{ type = "gha", scope = "ssh-python-node-${python}-node${node}" }]
  cache-to   = [{ type = "gha", scope = "ssh-python-node-${python}-node${node}", mode = "max" }]
}

target "ssh-python-node-ffmpeg" {
  name = "ssh-python${replace(python, ".", "_")}-node${node}-ffmpeg"
  inherits = ["base"]

  context = "docker-images/ssh-python-node-ffmpeg"
  dockerfile = "Dockerfile"

  matrix = {
    python = python_versions
    node   = node_versions
  }

  args = {
    PYTHON_VERSION = "${python}"
    NODE_VERSION   = "${node}"
  }

  tags = [
    "${dockerhub}/ssh-python-node-ffmpeg:${python}-node${node}",
    "${ghcr}/ssh-python-node-ffmpeg:${python}-node${node}",
  ]

  cache-from = [{ type = "gha", scope = "ssh-python-node-ffmpeg-${python}-node${node}" }]
  cache-to   = [{ type = "gha", scope = "ssh-python-node-ffmpeg-${python}-node${node}", mode = "max" }]
}
