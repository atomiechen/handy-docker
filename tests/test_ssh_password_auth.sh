#!/usr/bin/env bash
set -euo pipefail

image=${1:?usage: test_ssh_password_auth.sh IMAGE}
suffix="${RANDOM}-$$"
key_only="handy-ssh-key-only-$suffix"
password_env="handy-ssh-password-env-$suffix"
password_file="handy-ssh-password-file-$suffix"
temp_dir=$(mktemp -d)

cleanup() {
  docker rm -f "$key_only" "$password_env" "$password_file" >/dev/null 2>&1 || true
  rm -rf "$temp_dir"
}
trap cleanup EXIT

password_hash=$(printf '%s' 'environment-test-password' | openssl passwd -6 -stdin)
secret_hash=$(printf '%s' 'secret-test-password' | openssl passwd -6 -stdin)
printf '%s\n' "$secret_hash" > "$temp_dir/salted_passwd"
chmod 600 "$temp_dir/salted_passwd"

docker run -d --name "$key_only" "$image" >/dev/null
docker run -d --name "$password_env" \
  -e SALTED_PASSWD="$password_hash" \
  "$image" >/dev/null
docker run -d --name "$password_file" \
  -e SALTED_PASSWD="$password_hash" \
  -e SALTED_PASSWD_FILE=/run/secrets/salted_passwd \
  --mount "type=bind,src=$temp_dir/salted_passwd,dst=/run/secrets/salted_passwd,readonly" \
  "$image" >/dev/null

for container in "$key_only" "$password_env" "$password_file"; do
  test "$(docker inspect --format '{{.State.Running}}' "$container")" = true
done

docker exec "$key_only" ps -p 1 -o args= |
  grep -F 'PasswordAuthentication=no'
docker exec "$password_env" ps -p 1 -o args= |
  grep -F 'PasswordAuthentication=yes'
docker exec "$password_file" ps -p 1 -o args= |
  grep -F 'PasswordAuthentication=yes'

key_only_shadow=$(docker exec "$key_only" getent shadow user)
key_only_hash=${key_only_shadow#*:}
key_only_hash=${key_only_hash%%:*}
case "$key_only_hash" in
  \!*|\*) ;;
  *) echo "key-only user unexpectedly has an unlocked password" >&2; exit 1 ;;
esac

password_env_shadow=$(docker exec "$password_env" getent shadow user)
password_env_hash=${password_env_shadow#*:}
password_env_hash=${password_env_hash%%:*}
test "$password_env_hash" = "$password_hash"

password_file_shadow=$(docker exec "$password_file" getent shadow user)
password_file_hash=${password_file_shadow#*:}
password_file_hash=${password_file_hash%%:*}
test "$password_file_hash" = "$secret_hash"

if docker run --rm \
  -e SALTED_PASSWD_FILE=/run/secrets/missing \
  "$image" /bin/true; then
  echo "missing SALTED_PASSWD_FILE unexpectedly succeeded" >&2
  exit 1
fi

echo "SSH password authentication policy tests passed"
