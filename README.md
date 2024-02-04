# openssh-server
[![Software License](https://img.shields.io/badge/License-MIT-orange.svg?style=flat-square)](https://github.com/gesquive/openssh-server/blob/master/LICENSE)
[![Build Status](https://img.shields.io/circleci/build/github/gesquive/openssh-server?style=flat-square)](https://circleci.com/gh/gesquive/openssh-server)
[![Docker Pulls](https://img.shields.io/docker/pulls/gesquive/openssh-server?style=flat-square)](https://hub.docker.com/r/gesquive/openssh-server)

A minimal Alpine Linux image running an openssh server with `rsync` and `sftp` support.

## Config Files
Configuration files are saved in the `/config` volume. The following files are used to configure sshd:

- `sshd_config` A [sshd conf](https://man.openbsd.org/sshd_config) file. This file is copied into the `/etc/ssh/sshd_config.d/` directory.
- `authorized_keys` The file that contains the public keys used for user authentication. The format is described in the AUTHORIZED_KEYS FILE FORMAT section of [sshd(8)](https://man.openbsd.org/sshd.8).
- `keys/ssh_host_(ecdsa|ed25519|rsa)_key` The private host key that can be generated with `ssh-keygen`. If these do not exist on runtime, they will be created and saved here.
- `keys/ssh_host_(ecdsa|ed25519|rsa)_key.pub` The public host key that can be generated with `ssh-keygen`. If these do not exist on runtime, they will be created and saved in the `keys` directory.

## Environment Variables
Configure `sshd` with the following environment variables:

- `SSHD_USERNAME` The username to create. If no user is specified a default `user` is created.
- `SSHD_PUBKEY` The ssh public key used for user authentication.
