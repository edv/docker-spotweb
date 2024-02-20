FROM alpine:3.19
LABEL maintainer "Erik de Vries <docker@erikdevries.nl>"

# Disable timeout for starting services to make "wait for sql" work
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
ENV TZ=Europe/Amsterdam
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
        php82 \
        php82-fpm \
        php82-curl \
        php82-dom \
        php82-gettext \
        php82-xml \
        php82-simplexml \
        php82-zip \
        php82-zlib \
        php82-gd \
        php82-openssl \
        php82-mysqli \
        php82-pdo \
        php82-pdo_mysql \
        php82-pgsql \
        php82-pdo_pgsql \
        php82-sqlite3 \
        php82-pdo_sqlite \
        php82-json \
        php82-mbstring \
        php82-ctype \
        php82-opcache \
        php82-session \
        mysql-client \
        mariadb-connector-c \
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