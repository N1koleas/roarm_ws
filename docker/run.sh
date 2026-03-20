#!/bin/bash
# Usage: ./run.sh m2 or ./run.sh m3 (default is m3)

MODEL=${1:-m3}   # if no argument, default to m3

if [[ "$MODEL" != "m2" && "$MODEL" != "m3" ]]; then
  echo "Usage: ./run.sh [m2|m3]"
  exit 1
fi

echo "Starting RoArm container with model $MODEL..."

xhost +si:localuser:$(whoami) >/dev/null 2>&1

docker run -it --rm \
  --user $(id -u):$(id -g) \
  -e DISPLAY=$DISPLAY \
  -e ROARM_MODEL=roarm_$MODEL \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  nikoleas/roarm-humble:latest
