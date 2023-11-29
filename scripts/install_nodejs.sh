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

PROJECT_VERSION_NODEJS="${PROJECT_VERSION_NODEJS:-20}"

apt-get -qy update &&
	apt-get -qy install ca-certificates curl gnupg &&
	mkdir -p /etc/apt/keyrings &&
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

if [ ! -f "/etc/apt/sources.list.d/nodesource.list" ]; then
	echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${PROJECT_VERSION_NODEJS}.x nodistro main" >/etc/apt/sources.list.d/nodesource.list
fi

echo "(!!!) Installing nodejs." &&
	apt-get -qy update &&
	apt-get -qy install nodejs &&
	npm install -g npm@latest &&
	npm install -g yarn
