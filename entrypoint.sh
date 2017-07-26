#!/bin/sh

until nc -z -v -w30 mysql 3306
do
  echo "Waiting for database connection..."
  sleep 2
done

# Create required database tables for Spotweb
/usr/bin/php5 /var/www/spotweb/bin/upgrade-db.php

# Reset password for admin to spotweb (default password)
/usr/bin/php5 /var/www/spotweb/bin/upgrade-db.php --reset-password admin

# Create directory to log output
mkdir -p /data/logs/supervisor

# Start supervisord which spawns nginx and php-fpm5
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
