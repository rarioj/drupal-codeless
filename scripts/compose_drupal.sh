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

PROJECT_MINIMUM_STABILITY="${PROJECT_MINIMUM_STABILITY:-alpha}"

if [ ! -f "composer.json" ] && [ -f ".project/instance/composer.json" ]; then
	echo "(!!!) Using existing composer.json." &&
		cp .project/instance/composer.json .
	if [ ! -f "composer.lock" ] && [ -f ".project/instance/composer.lock" ]; then
		echo "(!!!) Using existing composer.lock." &&
			cp .project/instance/composer.lock .
	fi
fi

if [ ! -f "composer.json" ]; then
	echo "(!!!) Running composer create-project." &&
		${_PROJECT_CMD_COMPOSER} create-project drupal/recommended-project .temp &&
		cp -rf .temp/. . &&
		rm -rf .temp &&
		${_PROJECT_CMD_COMPOSER} require --no-interaction drush/drush &&
		${_PROJECT_CMD_COMPOSER} config minimum-stability "${PROJECT_MINIMUM_STABILITY}" &&
		echo "_PROJECT_PHASE_COMPOSE_DRUPAL=create-project" >>.phase.env
else
	echo "(!!!) Running composer install." &&
		${_PROJECT_CMD_COMPOSER} install --no-interaction &&
		echo "_PROJECT_PHASE_COMPOSE_DRUPAL=install" >>.phase.env
fi
