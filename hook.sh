#!/usr/bin/env bash

# Called after a git push

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$THIS_DIR"
if ./build.sh; then
	./deploy.sh
        cd "$THIS_DIR/.."
        ./cleanup_data.sh
else
	echo "Building failed; not deploying"
	exit 1
fi
