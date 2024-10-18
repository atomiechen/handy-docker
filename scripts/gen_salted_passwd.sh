#!/bin/bash

set -e

echo "Generating salted password to file."

DEFAULT_FILE_PATH="./salted_passwd"

read -p "Enter the file path to save the result ($DEFAULT_FILE_PATH): " FILE_PATH

# remove leading and trailing whitespaces
FILE_PATH=$(echo $FILE_PATH | xargs)

# if FILE_PATH is empty, use the default value
FILE_PATH=${FILE_PATH:-$DEFAULT_FILE_PATH}

# check if the path is not a directory
if [ -d "$FILE_PATH" ]; then
    echo "$FILE_PATH is a directory."
    echo "Cancelled. No changes made."
    exit 1
fi

# check if the file already exists
if [ -f "$FILE_PATH" ]; then
    echo "Path already exists: $FILE_PATH"
    read -p "Overwrite (y/N)? " OVERWRITE_CHOICE
    if [[ $OVERWRITE_CHOICE != "y" && $OVERWRITE_CHOICE != "Y" ]]; then
        echo "Cancelled. No changes made."
        exit 1
    fi
fi

echo "Will save to: $FILE_PATH"

read -s -p "Enter password: " CLEAR_PASSWD
echo

read -p "Would you like to provide a custom salt? (y/N): " SALT_CHOICE

if [[ $SALT_CHOICE == "y" || $SALT_CHOICE == "Y" ]]; then
    read -p "Enter your custom salt: " SALT
else
    SALT=$(openssl rand -base64 12)
    echo "Generated random salt: $SALT"
fi

SALTED_PASSWD=$(printf $CLEAR_PASSWD | openssl passwd -6 -salt $SALT -stdin)

echo "$SALTED_PASSWD" > "$FILE_PATH"

echo "Salted password have been saved to: $FILE_PATH"
