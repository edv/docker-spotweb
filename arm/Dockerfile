FROM erikdevries/rpi-baseimage:latest
MAINTAINER Erik de Vries <docker@erikdevries.nl>

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add --no-cache \
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
        php7-ctype \
    && \
    git clone --depth 1 https://github.com/spotweb/spotweb.git /app && \
    sed -i "s/;date.timezone =/date.timezone = \"Europe\/Amsterdam\"/g" /etc/php7/php.ini

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

EXPOSE 80
