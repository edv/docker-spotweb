<?php
$dbsettings['engine'] = getenv('DB_ENGINE');
$dbsettings['host'] = sprintf('%s:%s', getenv('DB_HOST'), getenv('DB_PORT'));
$dbsettings['dbname'] = getenv('DB_NAME');
$dbsettings['user'] = getenv('DB_USER');
$dbsettings['pass'] = getenv('DB_PASS');
