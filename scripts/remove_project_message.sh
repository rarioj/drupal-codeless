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

if [ "${_PROJECT_PHASE_INSTALL_DRUPAL}" = "new" ]; then
	echo "(!!!) Removing drupal/core-project-message package." &&
		${_PROJECT_CMD_COMPOSER} remove --no-interaction drupal/core-project-message &&
		php /app/.project/tools/edit-json.php composer.json "config ### allow-plugins ### drupal/core-project-message ### NULL" &&
		php /app/.project/tools/edit-json.php composer.json "extra ### drupal-core-project-message ### NULL" &&
		${_PROJECT_CMD_COMPOSER} update --no-interaction
fi
