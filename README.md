## Goal

This is a simple example to demonstrate how to
setup a data transfer job that fetches
Google Pub/Sub messages and dumps them to BigQuery.

## Usage
```
export PROJECT_ID=<your-project-id-here>
./setup.sh
./publish-message.sh
./publish-message.sh
```

## Cleanup
```
./teardown.sh
```
