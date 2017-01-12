FROM hypriot/rpi-alpine
MAINTAINER Erik de Vries <docker@erikdevries.nl>

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add \
        git \
        nginx \
        php5 \
        php5-fpm \
        php5-curl \
        php5-dom \
        php5-gettext \
        php5-xml \
        php5-zip \
        php5-zlib \
        php5-gd \
        php5-openssl \
        php5-mysqli \
        php5-pdo \
        php5-pdo_mysql \
        php5-json \
        supervisor \
    && \
    git clone --depth 1 https://github.com/spotweb/spotweb.git /var/www/spotweb && \
    chown -R nobody:nobody /var/www/spotweb && \
    sed -i "s/date.timezone = UTC/date.timezone = \"Europe\/Amsterdam\"/g" /etc/php5/php.ini && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

VOLUME ["/config"]

COPY ./conf/cron/spotweb /etc/periodic/hourly/spotweb
RUN chmod +x /etc/periodic/hourly/spotweb
COPY ./conf/supervisord.conf /etc/supervisord.conf
COPY ./conf/nginx /etc/nginx
COPY ./conf/spotweb /var/www/spotweb
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
