<?php

$argv = $_SERVER['argv'];
$usage =
	'(USE) ' . $argv[0] . ' [json-file] [path ### to ### update ### value]' . PHP_EOL .
	'      Use ### to separate path.' . PHP_EOL .
	'(???) ' . $argv[0] . ' composer.json "extras ### patches ### module ### patch-description ### patch-value"'  . PHP_EOL;

if (empty($argv[1]) || !is_file($argv[1])) {
	echo $usage . PHP_EOL;
	echo '(ERR) Parameter [json-file] is required or file does not exist.' . PHP_EOL;
	exit();
}

$json_raw_data = file_get_contents($argv[1]);
$json_decoded = json_decode($json_raw_data);

if ($json_decoded === null) {
	echo $usage . PHP_EOL;
	echo '(ERR) Parameter [json-file] can not be parsed/decoded.' . PHP_EOL;
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

$pointer = &$json_decoded;
foreach ($path as $key) {
	if (is_array($pointer)) {
		$pointer = &$pointer[$key];
	} else if (is_object($pointer)) {
		$pointer = &$pointer->{"$key"};
	} else if (is_null($pointer)) {
		if (is_numeric($key)) {
			$pointer = [];
			$pointer = &$pointer[$key];
		} else {
			$pointer = new stdClass;
			$pointer = &$pointer->{"$key"};
		}
	}
}
if ($value === "NULL") {
	$value = null;
} else if ($value === "{}") {
	$value = new stdClass;
} else if ($value === "[]") {
	$value = [];
} else if ($value === "TRUE") {
	$value = true;
} else if ($value === "FALSE") {
	$value = false;
}
if (is_null($value)) {
	if (is_array($pointer)) {
		unset($pointer[$last_key]);
	} else if (is_object($pointer)) {
		unset($pointer->{"$last_key"});
	}
} else {
	if (is_array($pointer)) {
		if ($last_key === "@") {
			$pointer[] = $value;
		} else {
			$pointer[$last_key] = $value;
		}
	} else if (is_object($pointer)) {
		$pointer->{"$last_key"} = $value;
	} else if (is_null($pointer)) {
		if (is_numeric($last_key)) {
			$pointer = [];
			$pointer[$last_key] = $value;
		} else {
			$pointer = new stdClass;
			$pointer->{"$last_key"} = $value;
		}
	}
}

$output = json_encode($json_decoded, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . PHP_EOL;
file_put_contents($argv[1], $output);
