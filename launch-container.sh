#!/usr/bin/env sh
docker run \
  -e USER="$USER" -e LOGNAME="$USER" \
  -e HOME="/tmp/home" \
  -v "$PWD:/hf-grpo-tutorial" \
  -w /hf-grpo-tutorial \
  --gpus all \
  --rm -it devshell bash

#   this doesn't work as of now:
#   --user "$(id -u)":"$(id -g)" \
#   TODO: make the above work
