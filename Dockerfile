FROM alpine:3.21
LABEL maintainer "Erik de Vries <docker@erikdevries.nl>"

# Disable timeout for starting services to make "wait for sql" work
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
ENV TZ=Europe/Amsterdam
ENV DB_ENGINE=pdo_mysql
ENV DB_HOST=mysql
ENV DB_PORT=3306
ENV DB_NAME=spotweb
ENV DB_USER=spotweb
ENV DB_PASS=spotweb
# Default 5 minute interval configuration for Spotweb update cronjob
ENV CRON_INTERVAL="*/5 * * * *"

RUN apk --no-cache upgrade && \
    apk --no-cache add \
        bash \
        coreutils \
        ca-certificates \
        shadow \
        curl \
        git \
        nginx \
        tar \
        xz \
        tzdata \
        php84 \
        php84-fpm \
        php84-curl \
        php84-dom \
        php84-gettext \
        php84-xml \
        php84-simplexml \
        php84-zip \
        php84-zlib \
        php84-gd \
        php84-openssl \
        php84-pdo \
        php84-pdo_mysql \
        php84-pdo_pgsql \
        php84-pdo_sqlite \
        php84-json \
        php84-mbstring \
        php84-ctype \
        php84-opcache \
        php84-session \
        php84-intl \
        s6-overlay \
    && \
    # Symlink php84 to php
    ln -sf /usr/bin/php84 /usr/bin/php \
    && \
    # Symlink php-fpm84 to php-fpm
    ln -sf /usr/sbin/php-fpm84 /usr/sbin/php-fpm \
    && \
    git clone --depth=1 https://github.com/spotweb/spotweb.git /app \
    && \
    rm -rf /app/.git

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

# create default user / group and folders
RUN groupadd -g 1000 abc && \
    useradd -u 1000 -g abc -d /app -s /bin/false abc

EXPOSE 80

ENTRYPOINT ["/init"]