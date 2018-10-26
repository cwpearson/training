#!/bin/bash
#
# We achieve parallelism through multiprocessing for minigo.
# This technique is rather crude, but gives the necessary
# speedup to run the benchmark in a useful length of time.

set -e

SEED=$2

FILE="TERMINATE_FLAG"
rm -f $FILE


echo "====BEGIN INIT===="
GOPARAMS=$1 nvprof -o /research/mnt/timeline_init_%p.nvprof -f --profile-child-processes pynvtx.py --depth 3 loop_init.py
for i in {1..2};
do
echo "====BEGIN SELFPLAY====";
date;
GOPARAMS=$1 nvprof -o /research/mnt/timeline_selfplay_%p_$i.nvprof -f --profile-child-processes pynvtx.py --depth 3 loop_selfplay.py $SEED $i 2>&1
date;
echo "====END SELFPLAY====";

echo "====BEGIN TRAIN_EVAL====";
date;
GOPARAMS=$1 nvprof -o /research/mnt/timeline_train-eval_%p_$i.nvprof -f --profile-child-processes pynvtx.py --depth 3 loop_train_eval.py $SEED $i 2>&1
date;
echo "====END TRAIN_EVAL====";



if [ -f $FILE ]; then
   echo "$FILE exists: finished!"
   cat $FILE
   break
else
   echo "$FILE does not exist; looping again."
fi
done
