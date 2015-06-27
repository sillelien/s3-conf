#!/usr/bin/env sh

haveged -w 1024 &


if [ ! -f /etc/s3_conf_key.txt ]
then
    if [ -z "$S3_CONF_KEY" ]
    then
        echo "Generating random key, this is a once only action."
        dd if=/dev/urandom of=/etc/s3_conf_key.txt.bin count=1 bs=1024
        cat /etc/s3_conf_key.txt.bin | md5sum | cut -d' ' -f1 > /etc/s3_conf_key.txt
    else
        echo "$S3_CONF_KEY" > /etc/s3_conf_key.txt
    fi
fi

echo "*************************** VERY IMPORTANT ****************************"
echo "The key $(cat /etc/s3_conf_key.txt) is required to decrypt your environment file"
echo "at the beginning of any script that needs the environment variables add :"

if [ -n "$S3_CONF_KEY" ]
then
    echo '$(openssl enc -aes-256-cbc -d -a -k $S3_CONF_KEY -in /conf/env.sh.enc)'
else
    echo '$(openssl enc -aes-256-cbc -d -a -k ' $(cat /etc/s3_conf_key.txt) '-in /conf/env.sh.enc)'
fi

echo
echo
aws s3 cp s3://${S3_BUCKET}/${DEPLOY_ENV}-build-env.sh /tmp/env.sh
openssl enc -aes-256-cbc -a -e -in /tmp/env.sh -out /conf/env.sh.enc -k $(cat /etc/s3_conf_key.txt)
chmod 600 /conf/env.sh.enc
#one week
sleep 604800
