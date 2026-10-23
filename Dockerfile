# syntax=docker/dockerfile:1
FROM php:8.5-fpm-alpine
LABEL maintainer="Erik de Vries <docker@erikdevries.nl>"

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install PHP extensions not bundled with the official image. Kept in a separate
# layer so the (slow) compilation is cached as long as the base image is unchanged.
RUN install-php-extensions \
        gd \
        gettext \
        intl \
        pdo_mysql \
        pdo_pgsql \
        zip

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
        nginx \
        tar \
        xz \
        tzdata \
        s6-overlay

# Fetch Spotweb
ADD https://github.com/spotweb/spotweb.git#develop /app

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

# create default user / group and folders
RUN groupadd -g 1000 abc && \
    useradd -u 1000 -g abc -d /app -s /bin/false abc

EXPOSE 80

ENTRYPOINT ["/init"]