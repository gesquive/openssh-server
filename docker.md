# [gesquive/openssh-server](https://github.com/gesquive/openssh-server)
[![Software License](https://img.shields.io/badge/License-MIT-orange.svg?style=flat-square)](https://github.com/gesquive/openssh-server/blob/master/LICENSE)
[![Build Status](https://img.shields.io/circleci/build/github/gesquive/openssh-server?style=flat-square)](https://circleci.com/gh/gesquive/openssh-server)
[![Docker Pulls](https://img.shields.io/docker/pulls/gesquive/openssh-server?style=flat-square)](https://hub.docker.com/r/gesquive/openssh-server)
[![Github Release](https://img.shields.io/github/v/tag/gesquive/openssh-server?style=flat-square)](https://github.com/gesquive/openssh-server)

# Supported Architectures
This image supports multiple architectures:

- `amd64`, `x86-64`
- `armv7`, `armhf`
- `arm64`, `aarch64`

Docker images are uploaded with using Docker manifest lists to make multi-platform deployments easer. More info can be found from [Docker](https://github.com/distribution/distribution/blob/main/docs/content/spec/manifest-v2-2.md)

You can simply pull the image using `gesquive/openssh-server` and docker should retreive the correct image for your architecture.

# Supported Tags
If you want a specific version of `openssh-server` you can pull it by specifying a version tag.

## Version Tags
This image provides versions that are available via tags. 

| Tag    | Description |
| ------ | ----------- |
| `latest` | Latest stable release |
| `0.9.0`  | Stable release v0.9.0 |
| `0.9.0-<git_hash>` | Development preview of version v0.9.0 at the given git hash |

# Usage
Here are some example snippets to help you get started creating a docker container.

## Docker CLI
```shell
docker run \
  --name=openssh-server \
  -v path/to/config:/config \
  -v path/to/share:/share \
  --restart unless-stopped \
  gesquive/openssh-server
```

## Docker Compose
Compatible with docker-compose v2 schemas.

```docker
---
version: "2"
services:
  openssh-server:
    image: gesquive/openssh-server
    container_name: openssh-server
    volumes:
      - path/to/config:/config
      - path/to/share:/share
    restart: unless-stopped
```

# Parameters
The container defines the following parameters that you can set:

| Parameter | Function |
| --------- | -------- |
| `-v /config`  | The openssh-server config files go here |
| `-v /share`  | The default directory to ssh into |

# Environment Variables
Configure the container with the following environment variables or optionally mount a custom sshd config at `/config/sshd_config`.

### General Options
- `SSHD_USERNAME` The username to create, by default there is no password. Password based authentication is disabled.
- `SSHD_PUBKEY` The ssh public key to use as authentication, alternatively you can mount a custom file at `/config/authorized_keys`.
