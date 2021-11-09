FROM erikdevries/rpi-baseimage:latest
MAINTAINER Erik de Vries <docker@erikdevries.nl>

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add --no-cache \
        git \
        nginx \
        php8 \
        php8-fpm \
        php8-curl \
        php8-dom \
        php8-gettext \
        php8-xml \
        php8-simplexml \
        php8-zip \
        php8-zlib \
        php8-gd \
        php8-openssl \
        php8-mysqli \
        php8-pdo \
        php8-pdo_mysql \
        php8-pgsql \
        php8-pdo_pgsql \
        php8-sqlite3 \
        php8-pdo_sqlite \
        php8-json \
        php8-mbstring \
        php8-ctype \
        php8-opcache \
        php8-session \
        mysql-client \
    && \
    git clone --depth=1 https://github.com/spotweb/spotweb.git /app && \
    sed -i "s/;date.timezone =/date.timezone = \"Europe\/Amsterdam\"/g" /etc/php8/php.ini

RUN echo "*/5       *       *       *       *       run-parts /etc/periodic/5min" >> /etc/crontabs/root

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

EXPOSE 80
