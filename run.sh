#!/usr/bin/env sh
aws s3 cp s3://${S3_BUCKET}/${DEPLOY_ENV}-build-env.sh /config/env.sh
chmod 400 /config/env.sh
#one week
sleep 604800
