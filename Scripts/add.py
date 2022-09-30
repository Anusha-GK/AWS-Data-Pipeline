import sys
from operator import add
import argparse

from pyspark.sql import SparkSession

#input --> hdfs:///input/netflix_titles.csv
#output --> hdfs:///output/transformed_data



spark = SparkSession.builder.appName("App1").getOrCreate()
parser = argparse.ArgumentParser(description='Spark Job Arguments')
parser.add_argument("--input")
parser.add_argument("--output")
args = parser.parse_args()

input_file = args.input
output_file = args.output

df = spark.read.load(path = 'hdfs://{}'.format(input_file),
                header = 'true',
                 format='csv',
                inferSchema = 'true')
group_cols = ["country", "director"]
df2 = df.groupBy(group_cols).count()
df2.write.option("header","true").mode("overwrite").csv("hdfs://{}".format(output_file))
