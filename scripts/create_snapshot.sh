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

if [ -n "${1}" ]; then
	_PROJECT_PHASE_CREATE_SNAPSHOT="${1}"
else
	_PROJECT_PHASE_CREATE_SNAPSHOT="$(date -u +%Y%m%d%H%M%S)"
fi

if [ ! -d ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}" ]; then
	mkdir -p ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}"
fi

echo "_PROJECT_PHASE_CREATE_SNAPSHOT=${_PROJECT_PHASE_CREATE_SNAPSHOT}" >>.phase.env

if [ -d ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}" ]; then
	echo "(!!!) Copying composer file(s) to snapshot." &&
		cp composer.json ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/composer.json"
	if [ -f "composer.lock" ]; then
		cp composer.lock ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/composer.lock"
	fi
fi

if [ -d "config/sync" ] && [ -n "$(ls "config/sync")" ] && [ -d ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}" ]; then
	if [ -d ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/config/sync" ]; then
		rm -f ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/config/sync/"*
	else
		mkdir -p ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/config/sync"
	fi
	echo "(!!!) Copying configuration files to snapshot." &&
		cp -f config/sync/* ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/config/sync"
fi

if [ ! -f ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/README.md" ]; then
	echo "(>>>) Creating README file: .project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/README.md" &&
		{
			echo "## ${_PROJECT_PHASE_CREATE_SNAPSHOT}"
			echo ""
			echo "TODO: Snapshot description here."
		} >".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}/README.md"
fi

if [ -d ".project/snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}" ]; then
	echo "(!!!) Symlinking latest snapshot." &&
		rm -f .project/instance
	ln -sf "snapshots/${_PROJECT_PHASE_CREATE_SNAPSHOT}" .project/instance
fi
