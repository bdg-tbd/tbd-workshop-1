#!/usr/bin/env python
# Copyright 2018 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import print_function
import tempfile
from pyspark.sql import SparkSession

# change to your data bucket
DATA_BUCKET = "gs://tbd-2024l-9910-data/data/shakespeare/"

spark = SparkSession.builder.appName('Shakespeare WordCount').getOrCreate()

table = 'bigquery-public-data.samples.shakespeare'

df = spark.read.format('bigquery').load(table)
# Only these columns will be read
df = df.select('word', 'word_count')
# The filters that are allowed will be automatically pushed down.
# Those that are not will be computed client side
df = df.where("word_count > 0 AND word NOT LIKE '%\\'%'")
# Further processing is done inside Spark
df = df.groupBy('word').sum('word_count').withColumnRenamed('sum(word_count)', 'sum_word_count')
df = df.orderBy(df['sum_word_count'].desc()).cache()

print('The resulting schema is')
df.printSchema()

print('The top words in shakespeare are')
df.show()
df.write.mode("overwrite").orc(DATA_BUCKET)

spark.stop()
