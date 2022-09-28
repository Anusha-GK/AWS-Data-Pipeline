#!/usr/bin/env bash
set -ex

region=$1
cluster_name=$2
bucket_name=$3
task_runner_logs_path="s3://$bucket_name/logs/task_runner_emr/"
worker_group=$cluster_name

clusterId=$(aws emr create-cluster \
--name $cluster_name \
--region $region \
--use-default-roles \
--release-label emr-5.32.0 \
--instance-count 2 \
--instance-type m4.large \
--applications Name=JupyterHub Name=Spark Name=Hadoop \
--ec2-attributes KeyName=master_KP \
--log-uri s3://$bucket_name/logs/emr_logs/ \
--bootstrap-actions Name=InstallTaskRunner,Path="s3://$bucket_name/scripts/bootstrap_emr.sh",Args=["$region","$worker_group","$task_runner_logs_path"] \
--tags for-use-with-amazon-emr-managed-policies=true | jq --raw-output '.ClusterId')

cluster_state=$(aws emr describe-cluster --cluster-id $clusterId --region us-east-1 | jq --raw-output '.Cluster.Status.State')

while true; do
	if [[ "$cluster_state" = "WAITING" ]]
		then 
			exit 0
	elif [[ "$cluster_state" = "TERMINATING" ]] || [[ "$cluster_state" = "TERMINATED" ]] || [[ "$cluster_state" = "TERMINATED_WITH_ERRORS" ]]
		then 
			exit 1
	fi
	sleep 2m
	cluster_state=$(aws emr describe-cluster --cluster-id $clusterId  --region us-east-1 | jq --raw-output '.Cluster.Status.State')
done
