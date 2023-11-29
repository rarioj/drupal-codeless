<?php

require __DIR__ . '/../../vendor/autoload.php';

use Drupal\Component\Serialization\Yaml;

$argv = $_SERVER['argv'];
$usage =
  '(USE) ' . $argv[0] . ' [yaml-file] [path ### to ### update ### value]' . PHP_EOL .
  '      Use ### to separate path.' . PHP_EOL .
  '(???) ' . $argv[0] . ' theme.info.yml "regions ### navbar_top ### Navbar top"'  . PHP_EOL;

if (empty($argv[1]) || !is_file($argv[1])) {
  echo $usage . PHP_EOL;
  echo '(ERR) Parameter [yaml-file] is required or file does not exist.' . PHP_EOL;
  exit();
}

$yaml_decoded = Yaml::decode(file_get_contents($argv[1]));

if ($yaml_decoded === null) {
  echo $usage . PHP_EOL;
  echo '(ERR) Parameter [yaml-file] can not be parsed/decoded.' . PHP_EOL;
  exit();
}

if (empty($argv[2])) {
  echo $usage . PHP_EOL;
  echo '(ERR) Parameter [path ### to ### update ### value] is required.' . PHP_EOL;
  exit();
}

$path = explode('###', $argv[2]);
$path = array_filter($path);
$path = array_map('trim', $path);

if (count($path) < 2) {
  echo $usage . PHP_EOL;
  echo '(ERR) Parameter [path ### to ### update ### value] needs at least 2 elements.' . PHP_EOL;
  exit();
}

echo $argv[1] . ': ' . implode(' > ', $path) . PHP_EOL;

$value = array_pop($path);
$last_key = array_pop($path);

$pointer = &$yaml_decoded;
foreach ($path as $key) {
  if (is_array($pointer)) {
    $pointer = &$pointer[$key];
  } else if (is_null($pointer)) {
    $pointer = [];
    $pointer = &$pointer[$key];
  }
}
if ($value === "NULL") {
  $value = null;
} else if ($value === "[]") {
  $value = [];
} else if ($value === "TRUE") {
  $value = true;
} else if ($value === "FALSE") {
  $value = false;
}
if (is_null($value)) {
  unset($pointer[$last_key]);
} else {
  if (is_array($pointer)) {
    if ($last_key === "@") {
      $pointer[] = $value;
    } else {
      $pointer[$last_key] = $value;
    }
  } else if (is_null($pointer)) {
    $pointer = [];
    $pointer[$last_key] = $value;
  }
}

$output = Yaml::encode($yaml_decoded);
file_put_contents($argv[1], $output);
