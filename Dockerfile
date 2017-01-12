FROM hypriot/rpi-alpine
MAINTAINER Erik de Vries <docker@erikdevries.nl>

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add \
        git \
        nginx \
        php7 \
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
        php7-mysqli \
        php7-pdo \
        php7-pdo_mysql \
        php7-session \
        php7-json \
        supervisor \
    && \
    git clone --depth 1 https://github.com/spotweb/spotweb.git /var/www/spotweb && \
    chown -R nobody:nobody /var/www/spotweb && \
    sed -i "s/;date.timezone =/date.timezone = \"Europe\/Amsterdam\"/g" /etc/php7/php.ini && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

VOLUME ["/config"]

COPY ./conf/spotweb.cron /etc/crontabs/spotweb
COPY ./conf/supervisord.conf /etc/supervisord.conf
COPY ./conf/nginx /etc/nginx
COPY ./conf/spotweb /var/www/spotweb
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
