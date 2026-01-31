#!/usr/bin/env sh

# Parse arguments
GPU_FLAG="--gpus all"
while [ $# -gt 0 ]; do
  case "$1" in
    --no-gpu)
      GPU_FLAG=""
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--no-gpu]"
      exit 1
      ;;
  esac
done

docker run \
  -e LOCAL_UID="$(id -u)" \
  -e LOCAL_GID="$(id -g)" \
  -e USER="$USER" \
  -e GROUP_NAME="$(id -gn)" \
  -v "$PWD:/hf-grpo-tutorial" \
  -w /hf-grpo-tutorial \
  $GPU_FLAG \
  --rm -it devenv bash
