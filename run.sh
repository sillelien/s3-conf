#!/usr/bin/env sh


resource="/${S3_BUCKET}/${S3_CONF_SOURCE_FILE}"
contentType="text/plain"

while true
do
    dateValue=`date -R`
    stringToSign="GET\n\n${contentType}\n${dateValue}\n${resource}"
    signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${AWS_SECRET_ACCESS_KEY} -binary | base64`
    curl -H "Host: ${S3_BUCKET}.s3.amazonaws.com" \
      -H "Date: ${dateValue}" \
      -H "Content-Type: ${contentType}" \
      -H "Authorization: AWS ${AWS_ACCESS_KEY_ID}:${signature}" \
      https://${S3_BUCKET}.s3.amazonaws.com/${S3_CONF_SOURCE_FILE} > /tmp/${S3_CONF_DEST_FILE}
    if grep "<Error><Code>" /conf/${S3_CONF_DEST_FILE}
    then
        exit 1
    fi
    if [ -f /conf/${S3_CONF_DEST_FILE} ]
    then
        chmod 600 /conf/${S3_CONF_DEST_FILE}
    fi
    cp -f /tmp/${S3_CONF_DEST_FILE} /conf/${S3_CONF_DEST_FILE}
    chmod 400 /conf/${S3_CONF_DEST_FILE}
    chown root:root /conf/${S3_CONF_DEST_FILE}
    if [ -n "$S3_CONF_AUTO_UPDATE_DELAY" ]
    then
        sleep "$S3_CONF_AUTO_UPDATE_DELAY"
    else
        #update after one hour
        sleep 3600
    fi
done
