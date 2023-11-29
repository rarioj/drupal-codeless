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
	echo "(!!!) Enabling core modules." &&
		${_PROJECT_CMD_DRUSH} pm:install -y action &&
		${_PROJECT_CMD_DRUSH} pm:install -y content_moderation &&
		${_PROJECT_CMD_DRUSH} pm:install -y inline_form_errors &&
		${_PROJECT_CMD_DRUSH} pm:install -y media_library &&
		${_PROJECT_CMD_DRUSH} pm:install -y responsive_image &&
		${_PROJECT_CMD_DRUSH} pm:install -y settings_tray &&
		echo "(!!!) Disabling shortcut module. [known issue: https://www.drupal.org/project/drupal/issues/2583113]" &&
		${_PROJECT_CMD_DRUSH} php:eval -y '\Drupal::entityTypeManager()->getStorage("shortcut_set")->load("default")->delete();' &&
		${_PROJECT_CMD_DRUSH} pm:uninstall -y shortcut
fi
