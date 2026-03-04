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

# read the salted password from file if exists
if [ -f "$SALTED_PASSWD_FILE" ]; then
  SALTED_PASSWD=$(cat "$SALTED_PASSWD_FILE")
fi

# if SALTED_PASSWD is set, change the password
if [ -n "$SALTED_PASSWD" ]; then
  echo "user:$SALTED_PASSWD" | chpasswd --encrypted
fi

# execute the main command
exec "$@"
