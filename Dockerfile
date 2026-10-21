FROM alpine:3.24
LABEL maintainer="Erik de Vries <docker@erikdevries.nl>"

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
        php85 \
        php85-fpm \
        php85-curl \
        php85-dom \
        php85-gettext \
        php85-xml \
        php85-simplexml \
        php85-zip \
        php85-zlib \
        php85-gd \
        php85-openssl \
        php85-pdo \
        php85-pdo_mysql \
        php85-pdo_pgsql \
        php85-pdo_sqlite \
        php85-json \
        php85-mbstring \
        php85-ctype \
        php85-session \
        php85-intl \
        s6-overlay \
    && \
    # Symlink php85 to php
    ln -sf /usr/bin/php85 /usr/bin/php \
    && \
    # Symlink php-fpm85 to php-fpm
    ln -sf /usr/sbin/php-fpm85 /usr/sbin/php-fpm \
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