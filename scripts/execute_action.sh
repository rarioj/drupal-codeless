#!/bin/sh

if [ -z "${LANDO_MOUNT}" ]; then
	echo "(ERR) This script can only run inside a Lando container."
	exit 1
fi

cd "${LANDO_MOUNT}" || exit 1

if [ -z "${1}" ]; then
	echo "(ERR) Missing action name as the first argument."
	exit 1
fi

_action="${1}"
shift

if [ -d ".project/actions/${_action}" ]; then
	cd ".project/actions/${_action}" || exit 1
	{
		# Same as Lando's @tooling.composer.cmd
		echo '_PROJECT_CMD_COMPOSER="php -d memory_limit=-1 /usr/local/bin/composer"'
		# Same as Lando's @tooling.drush.cmd
		echo '_PROJECT_CMD_DRUSH="php /app/vendor/drush/drush/drush"'
		# Define the current action
		echo "_PROJECT_PHASE_EXECUTE_ACTION=${_action}"
	} >"${LANDO_MOUNT}/.phase.env"
	echo "(>>>) Running action: ${_action}"
	for _script in $(find . -name "*.sh" | sort); do
		if file -L "${_script}" | grep -q "shell script"; then
			echo "(>>>) Running script: ${_script}" &&
				./"$(basename "${_script}")" "$@"
		fi
	done
	rm -f "${LANDO_MOUNT}/.phase.env"
else
	echo "(>>>) Skipping action: ${_action}"
fi
