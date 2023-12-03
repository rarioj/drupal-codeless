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

# The name is fixed to `codeless` for now. Nothing will ever get updated in
# this theme due to its codeless nature. Simply regenerate with a new proper
# project name for future real use.
PROJECT_THEME_NAME="codeless"
PROJECT_THEME_LABEL="Drupal Codeless"
PROJECT_THEME_DESCRIPTION="A basic no-code theme. DO NOT EDIT! Generate a new one for proper project use."

if [ ! -d "${LANDO_WEBROOT}/themes/custom/codeless" ]; then
	mkdir -p "${LANDO_WEBROOT}/themes/custom"
	# Check if Radix theme is available, otherwise generate theme based on Drupal starter kit.
	if [ -d "${LANDO_WEBROOT}/themes/contrib/radix" ] && [ -d "${LANDO_WEBROOT}/themes/contrib/radix/src/kits/radix_starterkit" ]; then
		# Generate theme based on Radix
		echo "(!!!) Generating codeless Radix theme." &&
			cp -r "${LANDO_WEBROOT}/themes/contrib/radix/src/kits/radix_starterkit" "${LANDO_WEBROOT}/themes/custom" &&
			php "${LANDO_WEBROOT}/core/scripts/drupal" generate-theme \
				--name "${PROJECT_THEME_LABEL}" \
				--path "themes/custom" \
				--description "${PROJECT_THEME_DESCRIPTION}" \
				--starterkit "radix_starterkit" \
				"${PROJECT_THEME_NAME}" &&
			rm -rf "${LANDO_WEBROOT}/themes/custom/radix_starterkit"
		cd "${LANDO_WEBROOT}/themes/custom/codeless" || exit
		npm install &&
			npm run production
		cd "${LANDO_MOUNT}" || exit
	else
		# Generate theme based on Stark
		echo "(!!!) Generating codeless starterkit theme." &&
			php "${LANDO_WEBROOT}/core/scripts/drupal" generate-theme \
				--name "${PROJECT_THEME_LABEL}" \
				--path "themes/custom" \
				--description "${PROJECT_THEME_DESCRIPTION}" \
				"${PROJECT_THEME_NAME}"
	fi
fi
