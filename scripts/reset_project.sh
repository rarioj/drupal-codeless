#!/bin/sh

cd "$(dirname "${0}")" || exit 1

cd ../.. || exit 1

if [ ! -f ".lando.yml" ]; then
	echo "(ERR) Missing .lando.yml file."
	exit 1
fi

if [ ! -d ".project" ]; then
	echo "(ERR) Missing .project directory."
	exit 1
fi

for _node in .[!.]*; do
	[ "${_node}" = ".lando.yml" ] && continue
	[ "${_node}" = ".project" ] && continue
	echo "(>>>) Removing: ${_node}"
	rm -rf "${_node}"
done

for _node in *; do
	[ "${_node}" = "*" ] && continue
	[ "${_node}" = "README.md" ] && continue
	echo "(>>>) Removing: ${_node}"
	rm -rf "${_node}"
done
