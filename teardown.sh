#!/bin/bash
# shellcheck disable=SC2086
set -u

project="$PROJECT_ID"
location=us-east4
dataset=$project:mydataset
table=$dataset.mytable
bucket=$project-mydataset
topic=mytopic
jobname=mytransferjob

bq --project_id $project --location=$location rm -f -t $table
bq --project_id $project --location=$location rm -f $dataset

gsutil -m rm -r gs://$bucket || true

gcloud pubsub subscriptions delete --project=$project $topic-subscription || true
gcloud pubsub topics delete --project=$project $topic || true

jobid=$(gcloud dataflow jobs list --status=active --project=$project --region=$location --filter="name=$jobname" --format="value(id)")
gcloud dataflow jobs cancel \
  --project=$project \
  --region=$location \
  "$jobid" || true
