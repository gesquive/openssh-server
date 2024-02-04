#! /bin/sh

CONFIG_PATH=/config
AUTH_KEYS_PATH=/etc/ssh/authorized_keys

# Set authorized keys
truncate -s0 "${AUTH_KEYS_PATH}"
if [ -n "${SSHD_PUBKEY}" ]; then
    echo "${SSHD_PUBKEY}" >> ${AUTH_KEYS_PATH}
fi
if [ -f ${CONFIG_PATH}/authorized_keys ]; then
    cat ${CONFIG_PATH}/authorized_keys >> ${AUTH_KEYS_PATH}
fi

if [ ! -s ${AUTH_KEYS_PATH} ]; then
    echo "WARNING: No authorized keys were found"
fi

# Create user/group
if [ -z "${SSHD_USERNAME}" ]; then
    # use default username
    SSHD_USERNAME="user"
fi
if ! getent passwd "${SSHD_USERNAME}" >/dev/null 2>&1; then
    echo "Adding user/group '${SSHD_USERNAME}'"
    addgroup -g 1000 "${SSHD_USERNAME}"
    adduser -u 1000 -G "${SSHD_USERNAME}" -h /share -D "${SSHD_USERNAME}"
    passwd -u "${SSHD_USERNAME}"
else
    echo "User/Group '${SSHD_USERNAME}' already exists"
fi

if [ -n "${SSHD_PASSWORD}" ]; then
    echo "Setting password for user '${SSHD_USERNAME}'"
    echo -e "${SSHD_PASSWORD}\n${SSHD_PASSWORD}" | passwd "${SSHD_USERNAME}"
fi

if [ -f ${CONFIG_PATH}/sshd_config ]; then
    echo "Installing user sshd config"
    cp ${CONFIG_PATH}/sshd_config /etc/ssh/sshd_config.d/user.conf
fi

# Configure host keys
if [ -f ${CONFIG_PATH}/keys/ssh_host_rsa_key ]; then
    echo "Using existing sshd host keys"
    for key in ssh_host_rsa_key ssh_host_ecdsa_key ssh_host_ed25519_key; do
        cp ${CONFIG_PATH}/keys/${key} /etc/ssh/${key}
        cp ${CONFIG_PATH}/keys/${key}.pub /etc/ssh/${key}.pub
        ssh-keygen -E sha256 -lf /etc/ssh/${key}
    done
else
    echo "Generating sshd host keys"
    ssh-keygen -A
    mkdir ${CONFIG_PATH}/keys
    for key in ssh_host_rsa_key ssh_host_ecdsa_key ssh_host_ed25519_key; do
        ssh-keygen -E sha256 -lf /etc/ssh/${key}
        cp /etc/ssh/${key} ${CONFIG_PATH}/keys/${key}
        cp /etc/ssh/${key}.pub ${CONFIG_PATH}/keys/${key}.pub
    done
fi

# /usr/sbin/sshd -D -e
/usr/sbin/sshd -V

if [ "$#" -gt 0 ]; then
    exec "$@"
fi
