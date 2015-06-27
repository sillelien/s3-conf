#!/usr/bin/env sh
if [ -f /conf/env.sh ]
then
    chmod 600 /conf/env.sh
fi
aws s3 cp s3://${S3_BUCKET}/${DEPLOY_ENV}-env.sh /conf/env.sh
chmod 400 /conf/env.sh
chown root:nobody /conf/env.sh
#one week
sleep 604800
