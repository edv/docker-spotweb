# Dockerfile to set up Spotweb on ARM based systems

[![Build Status](https://travis-ci.org/edv/docker-arm-spotweb.svg?branch=master)](https://travis-ci.org/edv/docker-arm-spotweb)

The main goal of this Dockerfile is to easily set up Spotweb using Docker on the Raspberry Pi 2/3 (or any compatible ARM chipset).

## Quick setup

* `docker-compose up`
* Visit `http://localhost:8080`
* Login with username `admin` and password `spotweb`
* Configure usenet server and wait for cronjob to update

## More details

* I decided on the following setup for this Docker image:
    * Image contains Nginx, PHP7 (fpm) and Crond
    * For the database a second MySQL image is used (as the data stored in the db is nice to have, but not critical)
    * To prevent having to configure Spotweb manually `upgrade-db.php` is run to upgrade the database and reset the password for the admin user
    * Crond is used to run the `retrieve.php` script which updates Spotweb with the latest headers from a configured usenet server, the crontab is run every hour at 15 minutes past the whole hour
    * The only required manual configuration is setting up a valid usenet server
