#!/usr/bin/env bash
set -e
echo "Obtaining credentials"
DB_PASSWORD=$(gcloud secrets versions access --project=${GCP_PROJECT} --secret=${DB_PASSWORD_SECRET_NAME} latest)
BACKEND_URI=${BACKEND_URI:-"mysql+pymysql://${DB_USERNAME}:${DB_PASSWORD}@/${DB_NAME}?unix_socket=/cloudsql/${DB_INSTANCE_CONNECTION_NAME:-"NOT_SET"}"}
mlflow server \
  --backend-store-uri ${BACKEND_URI} \
  --default-artifact-root ${GCS_BACKEND}/mlartifacts \
  --host 0.0.0.0 \
  --port ${PORT}
