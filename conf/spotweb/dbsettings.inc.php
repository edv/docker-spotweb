<?php
$dbsettings['engine'] = getenv('DB_ENGINE') ?: 'pdo_mysql';
$dbsettings['host'] = sprintf('%s:%s', getenv('DB_HOST') ?: 'mysql', getenv('DB_PORT') ?: '3306');
$dbsettings['dbname'] = getenv('DB_NAME') ?: 'spotweb';
$dbsettings['user'] = getenv('DB_USER') ?: 'spotweb';
$dbsettings['pass'] = getenv('DB_PASS') ?: 'spotweb';
