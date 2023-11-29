<?php

require __DIR__ . '/../../vendor/autoload.php';

use Drupal\Component\Serialization\Yaml;
use Drupal\Component\Uuid\Php;
use Drupal\Component\Utility\Crypt;

$config_last = dirname(__FILE__) . '/../../.project/instance/config/sync';
$config_temp = dirname(__FILE__) . '/../../config/temp';
$config_sync = dirname(__FILE__) . '/../../config/sync';

$existing_files = glob($config_sync . '/*.yml');
foreach ($existing_files as $existing_file) {
  if (is_file($existing_file)) {
    unlink($existing_file);
  }
}

$config_callbacks = [
  'core.extension.yml' => function ($yml) {
    unset($yml['module']['standard']);
    $yml['module']['minimal'] = 1000;
    $yml['profile'] = 'minimal';
    return $yml;
  },
];

$uuid_maps = [];
$uuid_service = new Php();

function _config_reset_map_uuid($array, $service)
{
  global $uuid_maps;
  if (!empty($array['uuid'])) {
    $old_uuid = $array['uuid'];
    $new_uuid = $service->generate();
    $uuid_maps[$old_uuid] = $new_uuid;
    $array['uuid'] = $new_uuid;
  }
  foreach ($array as $yml_key => $yml_value) {
    if (is_array($yml_value)) {
      $array[$yml_key] = _config_reset_map_uuid($yml_value, $service);
    }
  }
  return $array;
}

function _config_reset_fix_uuid($array)
{
  global $uuid_maps;
  foreach ($array as $yml_key => $yml_value) {
    if (is_array($yml_value)) {
      $array[$yml_key] = _config_reset_fix_uuid($yml_value);
    }
    if (array_key_exists($yml_key, $uuid_maps)) {
      $array_temp = $array[$yml_key];
      $array[$uuid_maps[$yml_key]] = $array_temp;
      unset($array[$yml_key]);
    }
  }
  return $array;
}

$config_files = glob($config_last . '/*.yml');
echo '(>>>) Processing config file: ';
foreach ($config_files as $config_file) {
  $base_file = basename($config_file);
  echo '.';
  $parsed_yml = Yaml::decode(file_get_contents($config_file));
  if (!empty($parsed_yml['uuid'])) {
    $old_uuid = $parsed_yml['uuid'];
    $new_uuid = $uuid_service->generate();
    $uuid_maps[$old_uuid] = $new_uuid;
    $parsed_yml['uuid'] = $new_uuid;
  }
  foreach ($parsed_yml as $yml_key => $yml_value) {
    if (is_array($yml_value)) {
      $parsed_yml[$yml_key] = _config_reset_map_uuid($yml_value, $uuid_service);
    }
  }
  if (!empty($config_callbacks[$base_file])) {
    $parsed_yml = $config_callbacks[$base_file]($parsed_yml);
  }
  file_put_contents($config_temp . '/' . $base_file, Yaml::encode($parsed_yml));
}
echo PHP_EOL;

$config_files = glob($config_temp . '/*.yml');
echo '(>>>) Finalising config file: ';
foreach ($config_files as $config_file) {
  $base_file = basename($config_file);
  echo '.';
  $parsed_yml = Yaml::decode(file_get_contents($config_file));
  $parsed_yml = _config_reset_fix_uuid($parsed_yml);
  if (!empty($parsed_yml['_core']) && !empty($parsed_yml['_core']['default_config_hash'])) {
    $old_core = $parsed_yml['_core'];
    unset($parsed_yml['_core']);
    $new_core_hash = Crypt::hashBase64(serialize($parsed_yml));
    $parsed_yml['_core'] = $old_core;
    $parsed_yml['_core']['default_config_hash'] = $new_core_hash;
  }
  file_put_contents($config_sync . '/' . $base_file, Yaml::encode($parsed_yml));
}
echo PHP_EOL;
