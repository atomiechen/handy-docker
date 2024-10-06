#!/bin/bash

echo "Generating salted password to file."

ABS_FILE_PATH=$(realpath ./pass)

read -p "Enter the file path to save the result ($ABS_FILE_PATH): " FILE_PATH

if [ -z "$FILE_PATH" ]; then
    FILE_PATH="./pass"
fi

ABS_FILE_PATH=$(realpath "$FILE_PATH")

if [ -f "$ABS_FILE_PATH" ]; then
    echo "$ABS_FILE_PATH already exists."
    read -p "Overwrite (y/N)? " OVERWRITE_CHOICE
    if [[ $OVERWRITE_CHOICE != "y" && $OVERWRITE_CHOICE != "Y" ]]; then
        echo "Cancelled. No changes made."
        exit 1
    fi
fi

read -p "Enter username: " USER
read -s -p "Enter password: " CLEAR_PASSWORD
echo

read -p "Would you like to provide a custom salt? (y/N): " SALT_CHOICE

if [[ $SALT_CHOICE == "y" || $SALT_CHOICE == "Y" ]]; then
    read -p "Enter your custom salt: " SALT
else
    SALT=$(openssl rand -base64 12)
    echo "Generated random salt: $SALT"
fi

SALTED=$(printf $CLEAR_PASSWORD | openssl passwd -6 -salt KdN5Re3X2X18 -stdin)

echo "$USER:$SALTED" > "$ABS_FILE_PATH"

echo "Username and salted password have been saved to: $ABS_FILE_PATH"
