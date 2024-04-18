# Dockerfile to set up Spotweb on x86 and arm based systems

The main goal of this project is to easily set up Spotweb using Docker on the Raspberry Pi (or any compatible arm chipset) and regular x86 chipsets.

## Getting started

The easiest way to get Spotweb up and running is using the included `docker-compose.yml` file. This will run Spotweb together with MySQL.

```bash
docker compose up -d
```

Have a look at the rest of documentation for more fine tuned configuration.

## Advanced database configuration

Spotweb requires a database to work. Out of the box this project supports MySQL, PostgreSQL and SQLite. Provide one or more of the following environment variables to configure the database:

- **DB_ENGINE**, one of:
  - `pdo_mysql` (MySQL, default)
  - `pdo_pgsql` (PostgreSQL)
  - `pdo_sqlite` (SQLite)
- **DB_HOST** (default = `mysql`)
- **DB_PORT** (default = `3306`)
- **DB_NAME** (default = `spotweb`)
- **DB_USER** (default = `spotweb`)
- **DB_PASS** (default = `spotweb`)

### Examples

Example Docker Compose files are included in the `examples` directory.

#### MySQL

When no environment variables are configured, MySQL settings will be used as default.

See the included `examples/docker-compose-mysql.yml`.

#### PostgreSQL

To use PostgreSQL have a look at `examples/docker-compose-postgres.yml` on how to set-up the environment variables and how to include the PostgreSQL database Docker container.

#### SQLite

SQLite is a light-weight serverless database engine and stores all content in a single file. Note that SQLite support in Spotweb is the least-tested database mode. Please report any issues to the [Spotweb project](https://github.com/spotweb/spotweb).

See `examples/docker-compose-sqlite.yml` for an example Docker Compose setup to use SQLite.

- Change the `DB_ENGINE` variable to `pdo_sqlite`
- Set the path to the database file in `DB_NAME` (e.g. `/data/spotweb.db3`, when the database does not exist it will be created)
- Make sure your database directory (or file) is mounted as a volume to not lose all data when the container is rebuilt

```bash
docker run -p 8085:80 \
  --name spotweb -d \
  -e DB_ENGINE=pdo_sqlite \
  -e DB_NAME=/data/spotweb.db3 \
  -v /local/path/to/spotweb-data:/data:rw \
  erikdevries/spotweb
```

#### External database

To connect to an external database configure the `DB_HOST`. Make sure the database server allows external access and correct credentials and/or port settings are configured.

```bash
docker run -p 8085:80 \
  --name spotweb -d \
  -e DB_HOST=mysql.hostname \
  erikdevries/spotweb
```

## Configure Spotweb

- Visit `http://localhost:8085`
- Login with username `admin` and default password `spotweb`
- Configure usenet server, spot retention, etc. and wait for spots to appear (retrieval script by default runs once every 5 minutes, see below how to change this update interval)

## Change Spotweb update interval

- By default Spotweb will update every 5 minutes
- Change the `CRON_INTERVAL` environment variable to any valid cronjob expression (see e.g. https://cron.help/ for more information, default 5 minute interval is configured in the docker-compose.yml file as an example)
- Restart the Spotweb Docker container (during start-up it will display the current configured update interval)

## Store cache outside container

- By default Spotweb store cache (like images) inside of the Docker container (in `/app/cache`)
- This results in the cache being removed when the container is recreated (e.g. when a new Docker image is pulled)
- To retain this cache you can mount a volume to `/app/cache` see the commented lines in the included Docker Compose files on how to do this

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

## Use Spotweb as newznab provider (indexer)

If you want to use Spotweb with for example Sonarr or Radarr (or any tool that is compatible with newznab indexers), create a new (non admin) user in Spotweb and use the API key associated with this new user.

Next step is to set-up a custom newznab indexer in Sonarr or Radarr and point it to the Spotweb url with the API key from the newly created user.

## Additional information

- Spotweb is configured as an open system after running docker compose up, so everyone who can access the site can register an account (keep this in mind, and also make sure to change the admin password if you plan to expose Spotweb to the outside world!)
- See the [official Spotweb Wiki](https://github.com/spotweb/spotweb/wiki) for any questions regarding Spotweb
