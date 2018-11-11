#!/bin/bash
#
# We achieve parallelism through multiprocessing for minigo.
# This technique is rather crude, but gives the necessary
# speedup to run the benchmark in a useful length of time.

set -e

SEED=$2

FILE="TERMINATE_FLAG"
rm -f $FILE

NVPROF="nvprof -f --profile-all-processes"

echo "====BEGIN INIT===="
date;
$NVPROF -o /research/mnt/timeline_init_%p.nvprof &
pid=$!
sleep 3
GOPARAMS=$1 $NVPROF -o /research/mnt/timeline_init_%p.nvprof loop_init.py
kill -INT $pid
sleep 3

for i in {1..2};
do
echo "====BEGIN SELFPLAY====";
date;
$NVPROF -o /research/mnt/timeline_selfplay_%p_$i.nvprof &
pid=$!
sleep 3
GOPARAMS=$1 $NVPROF -o /research/mnt/timeline_selfplay_%p_$i.nvprof $PYNVTX loop_selfplay.py $SEED $i 2>&1
kill -INT $pid
sleep 3

echo "====END SELFPLAY====";
date;

echo "====BEGIN TRAIN_EVAL====";
date;
$NVPROF -o /research/mnt/timeline_train_eval_%p_$i.nvprof &
pid=$!
sleep 3
GOPARAMS=$1 $NVPROF -o /research/mnt/timeline_train_eval_%p_$i.nvprof $PYNVTX loop_train_eval.py $SEED $i 2>&1
kill -INT $pid
sleep 3

echo "====END TRAIN_EVAL====";
date;


if [ -f $FILE ]; then
   echo "$FILE exists: finished!"
   cat $FILE
   break
else
   echo "$FILE does not exist; looping again."
fi
done

