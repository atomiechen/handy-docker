#!/bin/bash

# change the uid and gid of user in docker
usermod -u $USER_ID user
groupmod -g $GROUP_ID user

# set ownership of home directory to the user
chown -R user:user /home/user

# change .ssh directory and files permissions
mkdir -p /home/user/.ssh
chmod 700 /home/user/.ssh
# set permissions for common ssh files if they exist
[ -f /home/user/.ssh/config ] && chmod 600 /home/user/.ssh/config
[ -f /home/user/.ssh/authorized_keys ] && chmod 600 /home/user/.ssh/authorized_keys
[ -f /home/user/.ssh/known_hosts ] && chmod 644 /home/user/.ssh/known_hosts
# set permissions for private and public keys if they exist
for f in /home/user/.ssh/id_*; do
    [ -f "$f" ] && chmod 600 "$f"
done
for f in /home/user/.ssh/*.pub; do
    [ -f "$f" ] && chmod 644 "$f"
done

# Prefer a password hash mounted as a secret. Keep SALTED_PASSWD for backwards
# compatibility, but do not require either password source.
salted_passwd=${SALTED_PASSWD:-}
if [ -n "${SALTED_PASSWD_FILE:-}" ]; then
  if [ ! -r "$SALTED_PASSWD_FILE" ]; then
    echo "SALTED_PASSWD_FILE is not readable: $SALTED_PASSWD_FILE" >&2
    exit 1
  fi
  if ! salted_passwd=$(cat "$SALTED_PASSWD_FILE"); then
    echo "Failed to read SALTED_PASSWD_FILE: $SALTED_PASSWD_FILE" >&2
    exit 1
  fi
fi

# Enable password authentication only when a non-empty password hash is set.
password_authentication=no
if [ -n "$salted_passwd" ]; then
  if ! echo "user:$salted_passwd" | chpasswd --encrypted; then
    echo "Failed to set the user password from the supplied hash" >&2
    exit 1
  fi
  password_authentication=yes
fi

# Apply the authentication policy to the image's default SSH server command.
# Other commands keep their original arguments, which is useful for docker run
# diagnostics and explicit deployment-level overrides.
if [ "${1:-}" = "/usr/sbin/sshd" ]; then
  sshd_options=(-o "PasswordAuthentication=$password_authentication")
  if ! /usr/sbin/sshd -t "${sshd_options[@]}"; then
    exit 1
  fi
  exec "$@" "${sshd_options[@]}"
fi

exec "$@"
