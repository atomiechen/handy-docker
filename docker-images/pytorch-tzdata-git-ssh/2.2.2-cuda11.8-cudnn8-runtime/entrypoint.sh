#!/bin/bash

# change the uid and gid of user in docker
usermod -u $USER_ID user
groupmod -g $GROUP_ID user

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
