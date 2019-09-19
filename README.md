# Dockerfile to set up Spotweb on ARM and X86 based systems

[![Build Status](https://travis-ci.org/edv/docker-spotweb.svg?branch=master)](https://travis-ci.org/edv/docker-spotweb)

The main goal of this Dockerfile is to easily set up Spotweb using Docker on the Raspberry Pi 2/3 (or any compatible ARM chipset) and regular X86 chipsets.

## Quick setup using dockerfile

*Spotweb always requires a database server (MySQL), the easiest solution is to use the docker-compose setup. The other option is to manually specify an external server using the ENV variables below.*

`docker run -p 8080:80 --name spotweb -d -v /etc/localtime:/etc/localtime:ro erikdevries/spotweb`

Provide one or more of the following environment variables to configure the database server (all optional, default values are given below):
* DB_ENGINE (default = `pdo_mysql`)
* DB_HOST (default = `mysql`)
* DB_PORT (default = `3306`)
* DB_NAME (default = `spotweb`)
* DB_USER (default = `spotweb`)
* DB_PASS (default = `spotweb`)

E.g. to configure server with host `some.external.mysql-server.com` and port `6612` do the following:

`docker run -p 8080:80 --name spotweb -d -v /etc/localtime:/etc/localtime:ro -e "DB_HOST=some.external.mysql-server.com" -e "DB_PORT=6612" erikdevries/spotweb`

## Quick setup using docker compose

* `docker-compose -f docker-compose-arm.yml up` or `docker-compose -f docker-compose-x86.yml up` depending on cpu architecture
* Visit `http://localhost:8080`
* Login with username `admin` and password `spotweb`
* Configure usenet server and wait for cronjob to update (runs once every 15 minutes)

## Information

* Spotweb is configured as an open system after running docker-compose up, so everyone who can access can register an account (keep this in mind)
* If you want to use the Spotweb API, create a new user and use the API key associated with that user
* If you would like to save nzb files to disk for (e.g.) SABnzbd to be picked up, configure docker-compose.yml to mount e.g. /nzb to some directory where nzb's need to be saved, and configure Spotweb to save NZB's to this directory on disk

## Docker setup

I decided on the following setup for this Docker image:
* Image contains NGINX, PHP 7 and Crond
* For the database a MySQL 5.x image is used (MySQL 8 can also be used)
* To prevent having to configure Spotweb manually `upgrade-db.php` is run to upgrade the database and reset the password for the admin user (so currently the `admin` always has password `spotweb`, you can change this after the first login)
* Crond is used to run the `retrieve.php` script which updates Spotweb with the latest headers from a configured usenet server, the crontab is run every 15 minutes
* The only required manual configuration is setting up a valid usenet server
* Depending on what you like, you can mount the /nzb volume and let Spotweb save nzb's to that directory (e.g. mount /nzb to a folder watched by sabnzbd)
