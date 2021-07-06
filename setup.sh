#!/bin/bash
# shellcheck disable=SC2086
set -u

# shellcheck disable=SC2164
assets="$( cd "$(dirname "$0")"; pwd -P )/bq-schema.json"
project=$PROJECT_ID
location=us-east4
dataset=$project:mydataset
table=$dataset.mytable
bucket=$project-mydataset
topic=mytopic
jobname=mytransferjob

bq --project_id $project --location=$location mk $dataset
bq --project_id $project --location=$location mk $table "$assets"

gsutil mb -p $project -l $location -b on gs://$bucket

gcloud pubsub topics create --project=$project $topic

gcloud dataflow jobs run $jobname \
  --project=$project \
  --gcs-location gs://dataflow-templates-$location/latest/PubSub_to_BigQuery \
  --region $location \
  --staging-location gs://$bucket/ps-to-bq \
  --parameters inputTopic=projects/$project/topics/$topic,outputTableSpec=$table
# note, if and only it complains, then prefix the table by $project:
# --parameters inputTopic=projects/$project/topics/$topic,outputTableSpec=$project:$table

gcloud pubsub subscriptions create --project=$project --topic=$topic --topic-project=$project $topic-subscription
