#!/bin/bash
# This script should be only executed in docker.
# Run minigo... stop when it converges.
set -e

SEED=$1
mkdir -p /research/results/minigo/final/
cd /research/reinforcement/minigo
bash loop_main_profile.sh params/profile.json $SEED
