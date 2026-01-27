#!/usr/bin/env sh
docker run \
  -e LOCAL_UID="$(id -u)" \
  -e LOCAL_GID="$(id -g)" \
  -e USER="$USER" \
  -e GROUP_NAME="$(id -gn)" \
  -v "$PWD:/hf-grpo-tutorial" \
  -w /hf-grpo-tutorial \
  --gpus all \
  --rm -it devshell bash
