FROM alpine
MAINTAINER Erik de Vries <docker@erikdevries.nl>

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add \
        git \
        nginx \
        php7-fpm \
        php7-curl \
        php7-dom \
        php7-gettext \
        php7-mbstring \
        php7-xml \
        php7-zip \
        php7-zlib \
        php7-gd \
        php7-openssl \
        supervisor \
    && \
    git clone --depth 1 https://github.com/spotweb/spotweb.git /var/www/spotweb && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

VOLUME ["/config"]

#COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

#ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
