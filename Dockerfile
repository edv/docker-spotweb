FROM --platform=${BUILDPLATFORM} alpine:3.16
MAINTAINER Erik de Vries <docker@erikdevries.nl>

ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG S6_OVERLAY_VERSION="3.1.1.2"

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

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log

# s6 overlay
RUN \
  case ${TARGETPLATFORM} in \
    "linux/amd64")  S6_OVERLAY_ARCH=x86_64  ;; \
    "linux/arm64")  S6_OVERLAY_ARCH=arm  ;; \
    "linux/arm/v7") S6_OVERLAY_ARCH=armhf  ;; \
  esac; \
  && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -xzC / \
  && curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz | tar -xzC /

# create default user / group and folders
RUN groupadd -g 1000 abc && \
    useradd -u 1000 -g abc -d /app -s /bin/false abc && \
    mkdir -p \
	    /app \
	    /config

EXPOSE 80

ENTRYPOINT ["/init"]