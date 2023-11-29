#!/bin/sh

if [ -z "${LANDO_MOUNT}" ]; then
	echo "(ERR) This script can only run inside a Lando container."
	exit 1
fi

cd "${LANDO_MOUNT}" || exit 1

if [ -f ".phase.env" ]; then
	# shellcheck disable=SC1091
	. ./.phase.env
fi

if [ ! -f "composer.json" ]; then
	echo "(ERR) Missing composer.json file."
	exit 1
fi

if ${_PROJECT_CMD_DRUSH} sql:query 'SELECT * FROM config LIMIT 0,1' >/dev/null 2>&1; then
	echo "(!!!) Exporting configuration files." &&
		${_PROJECT_CMD_DRUSH} config:export -y
fi
