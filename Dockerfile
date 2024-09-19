FROM alpine:latest
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

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add --no-cache \
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
        php83 \
        php83-fpm \
        php83-curl \
        php83-dom \
        php83-gettext \
        php83-xml \
        php83-simplexml \
        php83-zip \
        php83-zlib \
        php83-gd \
        php83-openssl \
        php83-mysqli \
        php83-pdo \
        php83-pdo_mysql \
        php83-pgsql \
        php83-pdo_pgsql \
        php83-sqlite3 \
        php83-pdo_sqlite \
        php83-json \
        php83-mbstring \
        php83-ctype \
        php83-opcache \
        php83-session \
        mysql-client \
        mariadb-connector-c \
        postgresql-client \
        sqlite \
        s6-overlay \
    && \
    git clone --depth=1 https://github.com/spotweb/spotweb.git /app

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

# create default user / group and folders
RUN groupadd -g 1000 abc && \
    useradd -u 1000 -g abc -d /app -s /bin/false abc

EXPOSE 80

ENTRYPOINT ["/init"]