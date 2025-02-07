#!/usr/bin/env php
<?php

error_reporting(2147483647);

try {
  require_once __DIR__ . '/vendor/autoload.php';

  // Initialize the Spotweb base classes
  $bootstrap = new Bootstrap();

  // No need to call boot, as we only need basic access to the db (boot also causes a problem when db is not yet fully configured)
  $daoFactory = $bootstrap->getDaoFactory();

  /*
     * disable timing, all queries which are ran by retrieve this would make it use
     * large amounts of memory
     */
  SpotTiming::disable();

  // Initialize commandline arguments
  SpotCommandline::initialize(['debug', 'get_nntp_configured', 'get_admin_lastlogin'], ['debug' => false, 'get_nntp_configured' => false, 'get_admin_lastlogin' => false]);

  // Initialize translation to english
  SpotTranslation::initialize('en_US');

  /*
     * Do we need to debuglog this session? Generates loads of
     * output
     */
  $debugLog = SpotCommandline::get('debug');
  if ($debugLog) {
    SpotDebug::enable(SpotDebug::TRACE);
  } else {
    SpotDebug::disable();
  } // if

  // ACTUAL STUFF FOLLOWS HERE
  $getNntpConfigured = SpotCommandline::get('get_nntp_configured');
  $getAdminLastlogin = SpotCommandline::get('get_admin_lastlogin');
  if ($getNntpConfigured) {
    $settingsDao = $daoFactory->getSettingDao();
    $settings = $settingsDao->getAllSettings();
    $numConfigs = 0;
    if (strlen(trim($settings['nntp_nzb']['host'])) > 0) {
      $numConfigs++;
    }
    if (strlen(trim($settings['nntp_hdr']['host'])) > 0) {
      $numConfigs++;
    }
    echo $numConfigs;
  } elseif ($getAdminLastlogin) {
    $userDao = $daoFactory->getUserDao();
    $adminId = $userDao->findUserIdForName('admin');
    $adminUser = $userDao->getUser($adminId);
    echo $adminUser['lastlogin'];
  } else {
    echo 'Syntax: ' . $argv[0] . ' --get_nntp_configured|--get_admin_lastlogin' . PHP_EOL;
  }
} catch (DatabaseConnectionException $x) {
  echo 'Unable to connect to database: ' . $x->getMessage() . PHP_EOL;
} // catch

catch (InvalidOwnSettingsSettingException $x) {
  echo 'There is an error in your ownsettings.php' . PHP_EOL . PHP_EOL;
  echo $x->getMessage() . PHP_EOL;
} // InvalidOwnSettingsSetting

catch (Exception $x) {
  echo PHP_EOL . PHP_EOL;
  echo 'SpotWeb v' . SPOTWEB_VERSION . ' on PHP v' . PHP_VERSION . ' crashed' . PHP_EOL . PHP_EOL;
  echo 'Fatal error occured:' . PHP_EOL;
  echo '  ' . $x->getMessage() . PHP_EOL . PHP_EOL;
  echo PHP_EOL . PHP_EOL;
  echo $x->getTraceAsString();
  echo PHP_EOL . PHP_EOL;
  exit();
} // catch