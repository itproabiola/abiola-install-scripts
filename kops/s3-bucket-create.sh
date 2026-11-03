#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Kops S3 state bucket
AWS_REGION="us-east-1"
BUCKET_NAME="abiola-kops-state-$(date +%s)-$RANDOM"

echo "S3 bucket: $BUCKET_NAME"
echo "Region: $AWS_REGION"

echo "This script will create an AWS S3 bucket."
read -r -p "Type CREATE to continue: " CONFIRM

if [[ "$CONFIRM" != "CREATE" ]]; then
    echo "Operation cancelled."
    exit 1
fi

aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION"

aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled

echo
echo "KOPS_STATE_STORE=s3://$BUCKET_NAME"
echo "Save this value for your Kops configuration."
