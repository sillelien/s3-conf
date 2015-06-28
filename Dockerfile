FROM alpine
VOLUME /conf
RUN apk -Uuv add openssl curl && rm /var/cache/apk/*
COPY run.sh /run.sh
RUN chmod 755 /run.sh
CMD /run.sh