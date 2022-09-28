#!/usr/bin/env bash
# set -ex

region=$1
worker_group=$2
tsk_s3_log_folder=$3

#!/bin/bash
if grep isMaster /mnt/var/lib/info/instance.json | grep false;
then        
    echo "This is not master node, do nothing,exiting"
    exit 0
fi
curl https://s3.amazonaws.com/datapipeline-us-east-1/us-east-1/software/latest/TaskRunner/TaskRunner-1.0.jar -o ~/TaskRunner.jar
nohup java -jar ~/TaskRunner.jar --workerGroup=$worker_group --region=$region --logUri=$tsk_s3_log_folder &>/dev/null &



