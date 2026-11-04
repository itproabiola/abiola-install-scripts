#!/usr/bin/env bash
set -Eeuo pipefail

REGION="${AWS_REGION:-ca-central-1}"
AMI_ID="${AMI_ID:?Set AMI_ID to a valid AMI in the selected region}"
INSTANCE_TYPE="${INSTANCE_TYPE:-t3.micro}"
COUNT="${INSTANCE_COUNT:-1}"
KEY_NAME="${KEY_NAME:?Set KEY_NAME}"
SECURITY_GROUP_ID="${SECURITY_GROUP_ID:?Set SECURITY_GROUP_ID}"
SUBNET_ID="${SUBNET_ID:?Set SUBNET_ID}"

command -v aws >/dev/null || { echo "AWS CLI is required."; exit 1; }
[[ "$COUNT" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid instance count."; exit 1; }

echo "AWS account:"
aws sts get-caller-identity
echo "Region: $REGION | AMI: $AMI_ID | Type: $INSTANCE_TYPE | Count: $COUNT"

if [[ "${1:-}" != "--execute" ]]; then
  echo "DRY RUN: no EC2 instances will be created."
  aws ec2 run-instances \
    --image-id "$AMI_ID" --count "$COUNT" \
    --instance-type "$INSTANCE_TYPE" --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --subnet-id "$SUBNET_ID" --region "$REGION" --dry-run
  exit 0
fi

[[ "${CONFIRM_LAUNCH:-}" == "YES" ]] || {
  echo "Set CONFIRM_LAUNCH=YES to confirm actual provisioning."
  exit 1
}

aws ec2 run-instances \
  --image-id "$AMI_ID" --count "$COUNT" \
  --instance-type "$INSTANCE_TYPE" --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --subnet-id "$SUBNET_ID" --region "$REGION"
