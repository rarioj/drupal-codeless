#!/bin/sh

if [ -z "${LANDO_MOUNT}" ] || [ -z "${LANDO_WEBROOT}" ] || [ -z "${LANDO_APP_NAME}" ]; then
	echo "(ERR) This script can only run inside a Lando container."
	exit 1
fi

cd "${LANDO_MOUNT}" || exit 1

if [ -f ".phase.env" ]; then
	# shellcheck disable=SC1091
	. ./.phase.env
fi

PROJECT_NAME="${PROJECT_NAME:-Drupal Codeless}"
PROJECT_ADMIN_MAIL="${PROJECT_ADMIN_MAIL:-admin@example.com}"
PROJECT_ADMIN_NAME="${PROJECT_ADMIN_NAME:-admin}"
PROJECT_ADMIN_PASS="${PROJECT_ADMIN_PASS:-password}"
PROJECT_DATABASE="${PROJECT_DATABASE:-mysql://drupal10:drupal10@database/drupal10}"
PROJECT_CONFIG_RESET="${PROJECT_CONFIG_RESET:-0}"

if [ ! -f "${LANDO_WEBROOT}/sites/default/settings.php" ]; then
	if [ -f "${LANDO_WEBROOT}/sites/default/default.settings.php" ]; then
		cp "${LANDO_WEBROOT}/sites/default/default.settings.php" "${LANDO_WEBROOT}/sites/default/settings.php" &&
			echo >>"${LANDO_WEBROOT}/sites/default/settings.php" &&
			echo "\$settings['trusted_host_patterns'][] = '^${LANDO_APP_NAME}\.lndo\.site';" >>"${LANDO_WEBROOT}/sites/default/settings.php" &&
			echo "\$settings['trusted_host_patterns'][] = '^oembed\.${LANDO_APP_NAME}\.lndo\.site';" >>"${LANDO_WEBROOT}/sites/default/settings.php" &&
			echo >>"${LANDO_WEBROOT}/sites/default/settings.php"
	fi
else
	if ${_PROJECT_CMD_DRUSH} sql:query 'SELECT * FROM config LIMIT 0,1' >/dev/null 2>&1; then
		echo "(!!!) Drupal already installed." &&
			_PROJECT_PHASE_INSTALL_DRUPAL=installed
	fi
fi

if [ ! -f "salt.txt" ]; then
	if [ "${PROJECT_CONFIG_RESET}" = "0" ]; then
		echo "uYT3MD;$:]~agn6Vc?&,XAh#Fx-@UQ^4t_JeWr+Pv%S/8KNGLqeh?kcmUZ8adSbV" >salt.txt
	else
		php -r 'echo substr(strtr(base64_encode(hex2bin(bin2hex(random_bytes(128)))), "+", "."), 0, 64);' >salt.txt
	fi
	echo "\$settings['hash_salt'] = file_get_contents('../salt.txt');" >>"${LANDO_WEBROOT}/sites/default/settings.php" &&
		echo >>"${LANDO_WEBROOT}/sites/default/settings.php"
fi

if [ ! -d "files-private" ]; then
	mkdir "files-private" &&
		echo "\$settings['file_private_path'] = '../files-private';" >>"${LANDO_WEBROOT}/sites/default/settings.php" &&
		echo >>"${LANDO_WEBROOT}/sites/default/settings.php"
fi

if [ ! -d "config/sync" ]; then
	mkdir -p "config/sync" &&
		echo "\$settings['config_sync_directory'] = '../config/sync';" >>"${LANDO_WEBROOT}/sites/default/settings.php" &&
		echo >>"${LANDO_WEBROOT}/sites/default/settings.php"
	if [ -d ".project/instance/config/sync" ] && [ -n "$(ls ".project/instance/config/sync")" ]; then
		if [ "${PROJECT_CONFIG_RESET}" = "0" ]; then
			cp -rf ".project/instance/config/sync/"* "config/sync"
		else
			if [ ! -d "config/temp" ]; then
				mkdir -p "config/temp"
			else
				rm -rf "config/temp"
				mkdir -p "config/temp"
			fi
			php "${LANDO_MOUNT}/.project/tools/config-reset.php" &&
				rm -rf "config/temp"
		fi
	fi
fi

if [ "${_PROJECT_PHASE_INSTALL_DRUPAL}" = "installed" ]; then
	echo "_PROJECT_PHASE_INSTALL_DRUPAL=installed" >>.phase.env
elif [ -d "config/sync" ] && [ -n "$(ls "config/sync")" ] && [ -f "${LANDO_WEBROOT}/sites/default/settings.php" ]; then
	echo "(!!!) Running Drupal site:install with existing config." &&
		php "${LANDO_MOUNT}/.project/tools/edit-yml.php" "config/sync/core.extension.yml" "profile ### minimal" &&
		php "${LANDO_MOUNT}/.project/tools/edit-yml.php" "config/sync/core.extension.yml" "module ### minimal ### 1000" &&
		php "${LANDO_MOUNT}/.project/tools/edit-yml.php" "config/sync/core.extension.yml" "module ### standard ### NULL" &&
		${_PROJECT_CMD_DRUSH} site:install -y --existing-config --db-url="${PROJECT_DATABASE}" --account-mail="${PROJECT_ADMIN_MAIL}" --account-name="${PROJECT_ADMIN_NAME}" --account-pass="${PROJECT_ADMIN_PASS}"
	echo "_PROJECT_PHASE_INSTALL_DRUPAL=existing" >>.phase.env
else
	echo "(!!!) Running Drupal site:install." &&
		${_PROJECT_CMD_DRUSH} site:install -y --db-url="${PROJECT_DATABASE}" --account-mail="${PROJECT_ADMIN_MAIL}" --account-name="${PROJECT_ADMIN_NAME}" --account-pass="${PROJECT_ADMIN_PASS}" &&
		${_PROJECT_CMD_DRUSH} config:set -y system.site name "${PROJECT_NAME}" &&
		${_PROJECT_CMD_DRUSH} config:set -y system.site mail "${PROJECT_ADMIN_MAIL}" &&
		${_PROJECT_CMD_DRUSH} config:set -y update.settings notification.emails.0 "${PROJECT_ADMIN_MAIL}"
	echo "_PROJECT_PHASE_INSTALL_DRUPAL=new" >>.phase.env
fi

${_PROJECT_CMD_DRUSH} core:cron -y &&
	${_PROJECT_CMD_DRUSH} cache:rebuild -y
