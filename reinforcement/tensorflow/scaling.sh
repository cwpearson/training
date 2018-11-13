#!/bin/bash
# This script should be only executed in docker.
# Run minigo... stop when it converges.
set -e

PARAMS_FILE=params/scaling.json

echo "==== hostname ===="
hostname

echo "==== lscpu ===="
lscpu

echo "==== nvidia-smi ===="
nvidia-smi

echo "==== params ===="
echo "reading from minigo/$PARAMS_FILE"
cat minigo/$PARAMS_FILE

SEED=$1
mkdir -p /research/results/minigo/final/
cd /research/reinforcement/minigo
bash loop_main_scaling.sh params/scaling.json $SEED

