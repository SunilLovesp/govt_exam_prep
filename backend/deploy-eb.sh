#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-examprep-backend}"
ENV_NAME="${ENV_NAME:-examprep-backend}"
AWS_REGION="${AWS_REGION:-ap-south-1}"

if ! command -v eb >/dev/null 2>&1; then
  echo "EB CLI is not installed. Install it with: pip install awsebcli"
  exit 1
fi

if [ ! -d ".elasticbeanstalk" ]; then
  eb init "$APP_NAME" --platform node.js --region "$AWS_REGION"
fi

if ! eb status "$ENV_NAME" >/dev/null 2>&1; then
  eb create "$ENV_NAME"
fi

eb deploy "$ENV_NAME"
eb status "$ENV_NAME"
