
# Data Processing using AWS Data Pipeline, S3 and EMR
## Project Overview

This code repository has all the code needed to setup a AWS Data Pipeline to do big data processing using spark application. For complete implementation details visit [here](https://medium.com/@anushagk1995/etl-pipeline-using-aws-datapipeline-emr-s3-and-pyspark-452fbc9a383a).

## Pre-requisites
- AWS account
- PySpark basics
- Shell scripting basics

## Getting Started

- Login to AWS console
- Create an S3 bucket and upload the files in the repo in the below structure
- Create an EC2 instance, install task runner and start task runner service. For detailed steps click here.
- Go to Data Pipeline, click create pipeline and upload the pipeline definition json file.
- Click activate and your pipeline starts running.

## Pipeline flow

We are going to setup a data pipeline to process the data daily, upon the arrival of a test.ready dummy file. We need to create an EMR cluster once the data arrives and start processing data. So first we will create an EC2 Instance, install and start task runnner service in it. 

Below are the different activities performed in the pipeline to achieve the required output.

1. Check if test.ready file exists. This is the Pre-Condition that has to be met for the active pipeline to start running.
2. Once Pre-Condition is met, create an EMR cluster and install & start the task runnner as a bootstrap action.
3. ShellActivity copies the input file from S3 to HDFS. Below commands are given as command in ShellActivity.
   ```
    aws s3 cp #{my_s3_input_data}  /home/hadoop
    hdfs dfs -mkdir /input
    hdfs dfs -copyFromLocal /home/hadoop/netflix_titles.csv /input
    ```
4. EMRActivity submits the PySpark application to the EMR cluster.
5. Once the data transformations are done. Another ShellActivity combines the output files into a single csv file and uploads to S3.
   ```
    hdfs dfs -getmerge /output/transformed_data /home/hadoop/output.csv
    aws s3 cp /home/hadoop/output.csv s3://<myBucket>/data/
    ```



