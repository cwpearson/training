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
GOPARAMS=$1 python3 loop_init.py
for i in {1..100};
do
echo -n "====BEGIN SELFPLAY $i==== ";
date;
GOPARAMS=$1 python3 loop_selfplay.py $SEED $i 2>&1
echo -n "====END SELFPLAY $i==== ";
date;

echo -n "====BEGIN TRAIN_EVAL $i==== ";
date;
GOPARAMS=$1 python3 loop_train_eval.py $SEED $i 2>&1
echo -n "====END TRAIN_EVAL $i==== ";
date;



if [ -f $FILE ]; then
   echo "$FILE exists: finished!"
   cat $FILE
   break
else
   echo "$FILE does not exist; looping again."
fi
done
