#!/bin/bash
# This script should be only executed in docker.
# Run minigo... stop when it converges.
set -e

PARAMS_FILE=params/profile.json

echo "==== hostname ===="
hostname

echo "==== lscpu ===="
lscpu

echo "==== nvidia-smi ===="
nvidia-smi

echo "==== PARAMS ===="
echo "loading from $PARAMS_FILE"
cat $PARAMS_FILE

SEED=$1
mkdir -p /research/results/minigo/final/
cd /research/reinforcement/minigo
bash loop_main_profile.sh $PARAMS_FILE $SEED
