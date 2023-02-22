FROM alpine:3.17
LABEL maintainer "Erik de Vries <docker@erikdevries.nl>"

# Disable timeout for starting services to make "wait for sql" work
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0
ENV TZ=Europe/Amsterdam

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
        php81 \
        php81-fpm \
        php81-curl \
        php81-dom \
        php81-gettext \
        php81-xml \
        php81-simplexml \
        php81-zip \
        php81-zlib \
        php81-gd \
        php81-openssl \
        php81-mysqli \
        php81-pdo \
        php81-pdo_mysql \
        php81-pgsql \
        php81-pdo_pgsql \
        php81-sqlite3 \
        php81-pdo_sqlite \
        php81-json \
        php81-mbstring \
        php81-ctype \
        php81-opcache \
        php81-session \
        mysql-client \
        mariadb-connector-c \
        s6-overlay \
    && \
    git clone --depth=1 https://github.com/spotweb/spotweb.git /app

RUN echo "*/5       *       *       *       *       run-parts /etc/periodic/5min" >> /etc/crontabs/root

# Configure Spotweb
COPY ./conf/spotweb /app

# Copy root filesystem
COPY rootfs /

# create default user / group and folders
RUN groupadd -g 1000 abc && \
    useradd -u 1000 -g abc -d /app -s /bin/false abc

EXPOSE 80

ENTRYPOINT ["/init"]