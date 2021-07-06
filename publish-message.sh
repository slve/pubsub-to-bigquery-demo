#!/bin/bash
set -u

project=$PROJECT_ID
topic=mytopic

gcloud pubsub topics publish --project=$project $topic \
  --attribute="origin=mysample,foo=bar" \
  --message='{
    "name": "myname",
    "date": "'"$(date +%Y-%m-%d\ %H:%M:%S.%N | cut -c1-26)"'",
    "attributes": [{"key":"key1", "value":"value1"}, {"key":"key2", "value":"value2"}],
    "tags": ["tag1", "tag2"]
  }'
