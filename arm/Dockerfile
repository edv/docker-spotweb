FROM hypriot/rpi-alpine:3.6
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
        php7-xml \
        php7-simplexml \
        php7-zip \
        php7-zlib \
        php7-gd \
        php7-openssl \
        php7-mysqli \
        php7-pdo \
        php7-pdo_mysql \
        php7-json \
        php7-mbstring \
        supervisor \
        sudo \
    && \
    git clone --depth 1 https://github.com/spotweb/spotweb.git /var/www/spotweb && \
    chown -R nobody:nobody /var/www/spotweb && \
    sed -i "s/date.timezone = UTC/date.timezone = \"Europe\/Amsterdam\"/g" /etc/php7/php.ini && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

VOLUME ["/config", "/nzb"]

COPY ./conf/cron/spotweb /etc/periodic/hourly/spotweb
RUN chmod +x /etc/periodic/hourly/spotweb
COPY ./conf/supervisord.conf /etc/supervisord.conf
COPY ./conf/nginx /etc/nginx
COPY ./conf/php-fpm/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./conf/spotweb /var/www/spotweb
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
