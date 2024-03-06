# Dockerfile to set up Spotweb on x86 and arm based systems

The main goal of this Dockerfile is to easily set up Spotweb using Docker on the Raspberry Pi (or any compatible arm chipset) and regular x86 chipsets.

## Quick setup

_Spotweb always requires a database server (e.g. MySQL), the easiest solution is to use the docker-compose setup. The other option is to manually specify an external database server using the ENV variables below._

Provide one or more of the following environment variables to configure the database server (all optional, default values are given below):

- TZ (default = `Europe/Amsterdam`)
- DB_ENGINE (default = `pdo_mysql`)
- DB_HOST (default = `mysql`)
- DB_PORT (default = `3306`)
- DB_NAME (default = `spotweb`)
- DB_USER (default = `spotweb`)
- DB_PASS (default = `spotweb`)

E.g. to configure MySQL database server with host `some.external.mysql-server.com`, port `6612` and timezone `Europe/London` do the following:

```
docker run -p 8085:80 \
  --name spotweb -d \
  -e DB_HOST=some.external.mysql-server.com \
  -e DB_PORT=6612 \
  -e TZ=Europe/London \
  erikdevries/spotweb
```

Instead of using the pre-build image on Docker Hub you can build the image locally, for example:

```
docker build -t spotweb .

docker run -p 8085:80 \
  --name spotweb -d \
  -e DB_HOST=some.external.mysql-server.com \
  -e DB_PORT=6612 \
  -e TZ=Europe/London \
  spotweb
```

## Quick setup using Docker Compose

Included are example Docker Compose files, modify them as desired (e.g. change the MySQL root password).

- `docker compose up` (to use pre-build image from Docker Hub) or `docker compose -f docker-compose-local.yml up` (to build the image locally)

## Configure Spotweb

- Visit `http://localhost:8085`
- Login with username `admin` and password `spotweb`
- Configure usenet server, spot retention, etc. and wait for spots to appear (retrieval script by default runs once every 5 minutes, see below how to change this update interval)

## Store cache outside container

- By default Spotweb store cache (like images) inside of the Docker container (in `/app/cache`)
- This results in the cache being removed when the container is recreated (e.g. when a new Docker image is pulled)
- To retain this cache you can mount a volume to `/app/cache` see the commented lines in the included Docker Compose files

## Change Spotweb update interval

- By default Spotweb will update every 5 minutes
- Change the `CRON_INTERVAL` environment variable to any valid cronjob expression (see e.g. https://cron.help/ for more information, default 5 minute interval is configured in the docker-compose.yml file as an example)
- Restart the Spotweb Docker container (during start-up it will display the current configured update interval)

## Change timezone

- Change the `TZ` environment variable to any valid timezone (e.g. Europe/Amsterdam or Europe/Lisbon)
- Restart the Spotweb Docker container

## Tip: Using `ownsettings.php`

You can override Spotweb settings by using a custom `ownsettings.php` file. In most cases there is no need to use this feature, so only use this when you know what you are doing!

The example below will mount `/external/ownsettings.php` to `/app/ownsettings.php` inside the container. Spotweb will see the ownsettings file and load it automatically.

```
volumes:
- /external/ownsettings.php:/app/ownsettings.php
```

## Information

- In the past separate images were created for x86 and arm in separate Docker Hub repositories, for the most up to date image please visit [Docker Hub](https://hub.docker.com/repository/docker/erikdevries/spotweb)
- Spotweb is configured as an open system after running docker compose up, so everyone who can access the site can register an account (keep this in mind, and also make sure to change the admin password if you plan to expose Spotweb to the outside world!)
- If you want to use the Spotweb API, create a new user and use the API key associated with that user
- See the [official Spotweb Wiki](https://github.com/spotweb/spotweb/wiki) for any questions regarding Spotweb
