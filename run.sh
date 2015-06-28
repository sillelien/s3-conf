#!/usr/bin/env sh
if [ -f /conf/env.sh ]
then
    chmod 600 /conf/env.sh
fi

while true
do
    resource="/${S3_BUCKET}/${DEPLOY_ENV}-env.sh"
    contentType="text/plain"
    dateValue=`date -R`
    stringToSign="GET\n\n${contentType}\n${dateValue}\n${resource}"
    signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${AWS_SECRET_ACCESS_KEY} -binary | base64`
    curl -H "Host: ${S3_BUCKET}.s3.amazonaws.com" \
      -H "Date: ${dateValue}" \
      -H "Content-Type: ${contentType}" \
      -H "Authorization: AWS ${AWS_ACCESS_KEY_ID}:${signature}" \
      https://${S3_BUCKET}.s3.amazonaws.com/${DEPLOY_ENV}-env.sh > /tmp/env.sh
    if grep "<Error><Code>" /conf/env.sh
    then
        exit 1
    fi
    cp -f /tmp/env.sh /conf/env.sh
    chmod 400 /conf/env.sh
    chown root:nobody /conf/env.sh
    if [ -n "$S3_CONF_AUTO_UPDATE_DELAY" ]
    then
        sleep "$S3_CONF_AUTO_UPDATE_DELAY"
    else
        #update after one hour
        sleep 3600
    fi
done
