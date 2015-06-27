FROM vizzbuzz/base-alpine
VOLUME /conf
RUN \
    mkdir -p /aws && \
    apk -Uuv add groff less haveged openssl python py-pip && \
    pip install awscli && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/*

WORKDIR /aws

ENV AWS_ACCESS_KEY_ID changeme
ENV AWS_SECRET_ACCESS_KEY changeme
ENV DEPLOY_ENV dev
ENV S3_BUCKET changeme

COPY run.sh /run.sh
RUN chmod 755 /run.sh
CMD /run.sh