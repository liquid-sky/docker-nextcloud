#!/bin/sh
set -eu

# Arrange
image=${1:-neverhood/nextcloud:33}

# Act
modules=$(docker run --rm --entrypoint php "$image" -m)

# Assert
missing=
for module in imagick sodium sysvsem; do
	if ! printf '%s\n' "$modules" | grep -qx "$module"; then
		missing="$missing $module"
	fi
done

if [ -n "$missing" ]; then
	echo "Missing PHP modules:$missing" >&2
	exit 1
fi

echo "Required PHP modules are available: imagick sodium sysvsem"
